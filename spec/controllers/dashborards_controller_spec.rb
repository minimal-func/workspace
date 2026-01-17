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
