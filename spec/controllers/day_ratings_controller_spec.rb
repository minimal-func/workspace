require 'rails_helper'

RSpec.describe DayRatingsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns paginated day ratings' do
      FactoryBot.create_list(:day_rating, 3, user: user)
      get :index
      expect(assigns(:day_ratings).size).to eq(3)
    end
  end
end
