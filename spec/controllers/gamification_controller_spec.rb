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
end
