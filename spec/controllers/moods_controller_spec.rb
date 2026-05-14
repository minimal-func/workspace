require 'rails_helper'

RSpec.describe MoodsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns paginated moods' do
      FactoryBot.create_list(:mood, 3, user: user)
      get :index
      expect(assigns(:moods).size).to eq(3)
    end
  end
end
