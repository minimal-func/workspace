require 'rails_helper'

RSpec.describe GamificationController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @achievements' do
      FactoryBot.create(:user_achievement, user: user)
      get :index
      expect(assigns(:achievements)).to be_present
    end

    it 'assigns @available_achievements' do
      FactoryBot.create(:achievement)
      get :index
      expect(assigns(:available_achievements)).to be_present
    end

    it 'assigns @points' do
      level = FactoryBot.create(:level, level_number: 1, points_required: 0)
      user.update(level: level)
      FactoryBot.create(:point, user: user, value: 50, action: 'create_project')
      get :index
      expect(assigns(:points)).to be_present
    end

    it 'assigns @level' do
      get :index
      expect(assigns(:level)).to be_nil
    end
  end

  describe 'POST #purchase_feature' do
    let!(:level1) { FactoryBot.create(:level, level_number: 1, points_required: 0, name: 'Beginner') }

    before do
      FactoryBot.create(:point, user: user, value: 300, action: 'initial_bonus')
      user.reload
    end

    it 'allows purchasing an unlocked feature for points' do
      post :purchase_feature, params: { feature: 'posts' }

      expect(response).to redirect_to(gamification_path)
      expect(user.reload.purchased_features).to include('posts')
      expect(user.total_points).to eq(50)
    end

    it 'does not allow purchasing when the user lacks enough points' do
      post :purchase_feature, params: { feature: 'materials' }

      expect(response).to redirect_to(gamification_path)
      expect(flash[:alert]).to include('You need 350 points to unlock Materials.')
    end
  end
end
