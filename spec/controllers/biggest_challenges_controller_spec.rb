require 'rails_helper'

RSpec.describe BiggestChallengesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns paginated biggest challenges' do
      FactoryBot.create_list(:biggest_challenge, 3, user: user)
      get :index
      expect(assigns(:biggest_challenges).size).to eq(3)
    end
  end
end
