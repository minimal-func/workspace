require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns the current user to @user' do
      get :index
      expect(assigns(:user)).to eq(user)
    end

    it 'assigns happiness insights from the last 7 days' do
      create(:mood, user: user, value: 4, created_at: 6.days.ago)
      create(:mood, user: user, value: 5, created_at: 4.days.ago)
      create(:mood, user: user, value: 8, created_at: 1.day.ago)
      create(:day_rating, user: user, value: 8, created_at: 2.days.ago)
      create(:energy_level, user: user, value: 6, created_at: 3.days.ago)
      create(:daily_gratitude, user: user, created_at: 6.days.ago)
      create(:daily_gratitude, user: user, created_at: 1.day.ago)
      create(:reflection, user: user, created_at: 5.days.ago)

      get :index

      expect(assigns(:happiness_score)).to eq(6.6)
      expect(assigns(:gratitude_days_count)).to eq(2)
      expect(assigns(:reflection_days_count)).to eq(1)
      expect(assigns(:happiness_trend)).to include('trending upward')
      expect(assigns(:happiness_focus)).to include('Mood is your biggest opportunity')
      expect(assigns(:weekly_happiness_metrics)).to include(
        hash_including(label: 'Mood', value: 5.7),
        hash_including(label: 'Alignment', value: 8.0),
        hash_including(label: 'Energy', value: 6.0)
      )
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) {
        {
          user: {
            today_daily_lessons_attributes: [{ content: 'Valid content' }],
            today_daily_gratitudes_attributes: [{ content: 'Valid content' }],
            today_reflections_attributes: [{ content: 'Valid content' }],
            today_biggest_challenges_attributes: [{ content: 'Valid content' }],
            today_moods_attributes: [{ value: 1 }],
            today_day_ratings_attributes: [{ value: 1 }],
            today_energy_levels_attributes: [{ value: 1 }]
          }
        }
      }

      it 'updates the user' do
        post :create, params: valid_attributes
        user.reload
        expect(user.today_daily_lessons.first.content).to eq('Valid content')
      end

      it 'redirects to the dashboards url' do
        post :create, params: valid_attributes
        expect(response).to redirect_to(dashboards_url)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) {
        {
          user: {
            today_daily_lessons_attributes: [{ content: '' }],
            today_daily_gratitudes_attributes: [{ content: '' }],
            today_reflections_attributes: [{ content: '' }],
            today_biggest_challenges_attributes: [{ content: '' }],
            today_moods_attributes: [{ value: nil }],
            today_day_ratings_attributes: [{ value: nil }],
            today_energy_levels_attributes: [{ value: nil }]
          }
        }
      }

      it 'does not update the user' do
        post :create, params: invalid_attributes
        user.reload
        expect(user.today_reflections.last).to be_nil
      end

      it 'renders the index template' do
        post :create, params: invalid_attributes
        expect(response).to render_template('index')
      end
    end
  end
end
