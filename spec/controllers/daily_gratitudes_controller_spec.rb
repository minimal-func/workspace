require 'rails_helper'

RSpec.describe DailyGratitudesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns paginated daily gratitudes' do
      FactoryBot.create_list(:daily_gratitude, 3, user: user)
      get :index
      expect(assigns(:daily_gratitudes).size).to eq(3)
    end
  end
end
