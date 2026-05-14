require 'rails_helper'

RSpec.describe DailyLessonsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns daily lessons ordered by created_at desc' do
      FactoryBot.create_list(:daily_lesson, 3, user: user)
      get :index
      expect(assigns(:daily_lessons).size).to eq(3)
    end
  end
end
