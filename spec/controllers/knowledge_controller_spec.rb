require 'rails_helper'

RSpec.describe KnowledgeController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @stats with zero counts when user has no entries' do
      get :index
      stats = assigns(:stats)
      expect(stats[:reflection_count]).to eq(0)
      expect(stats[:gratitude_count]).to eq(0)
      expect(stats[:lesson_count]).to eq(0)
      expect(stats[:challenge_count]).to eq(0)
      expect(stats[:post_count]).to eq(0)
      expect(stats[:link_count]).to eq(0)
      expect(stats[:material_count]).to eq(0)
      expect(stats[:total_entries]).to eq(0)
      expect(stats[:record_days]).to eq(0)
    end

    it 'assigns @stats with correct counts' do
      FactoryBot.create_list(:reflection, 2, user: user)
      FactoryBot.create_list(:daily_gratitude, 3, user: user)
      FactoryBot.create_list(:daily_lesson, 1, user: user)
      project = FactoryBot.create(:project, user: user)
      FactoryBot.create_list(:post, 2, project: project)
      FactoryBot.create_list(:saved_link, 1, project: project)

      get :index
      stats = assigns(:stats)
      expect(stats[:reflection_count]).to eq(2)
      expect(stats[:gratitude_count]).to eq(3)
      expect(stats[:lesson_count]).to eq(1)
      expect(stats[:post_count]).to eq(2)
      expect(stats[:link_count]).to eq(1)
    end

    it 'assigns @recent_items with combined entries sorted by date' do
      FactoryBot.create(:reflection, user: user, created_at: 1.day.ago)
      FactoryBot.create(:daily_gratitude, user: user, created_at: 2.days.ago)
      FactoryBot.create(:daily_lesson, user: user, created_at: 3.days.ago)

      get :index
      expect(assigns(:recent_items).size).to be >= 3
    end

    it 'assigns @ai_insight when reflections exist with body_json' do
      reflection = FactoryBot.create(:reflection, user: user)
      reflection.update_column(:body_json, {
        "blocks" => [
          { "type" => "paragraph", "data" => { "text" => "Today I learned something important about focus." } }
        ]
      })

      get :index
      expect(assigns(:ai_insight)).to be_present
      expect(assigns(:ai_insight)[:title]).to eq("Your Second Brain noticed something")
    end

    it 'assigns @ai_insight as nil when no reflections exist' do
      get :index
      expect(assigns(:ai_insight)).to be_nil
    end
  end

  describe 'POST #search' do
    before do
      FactoryBot.create(:daily_gratitude, content: "grateful for sunshine", user: user)
      FactoryBot.create(:daily_lesson, content: "lesson about patience", user: user)
      FactoryBot.create(:biggest_challenge, content: "challenge with focus", user: user)
      project = FactoryBot.create(:project, user: user)
      FactoryBot.create(:post, title: "Deep Work", short_description: "Notes on focus", project: project)
      FactoryBot.create(:saved_link, title: "Focus Article", url: "https://example.com/focus", project: project)
    end

    it 'returns matching results for a query' do
      post :search, params: { query: 'focus' }
      expect(assigns(:results)).to be_present
      expect(assigns(:results).size).to be > 0
    end

    it 'returns empty results for a non-matching query' do
      post :search, params: { query: 'zzzzzxyz' }
      expect(assigns(:results)).to be_empty
    end

    it 'does not crash on empty query' do
      post :search, params: { query: '' }
      expect(response).to be_successful
    end

    it 'renders the results partial when partial param is true' do
      post :search, params: { query: 'focus', partial: 'true' }
      expect(response).to render_template(partial: 'knowledge/_results')
    end
  end
end
