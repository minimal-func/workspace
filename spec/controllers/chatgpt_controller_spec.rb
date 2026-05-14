require 'rails_helper'

RSpec.describe ChatgptController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'returns a JSON response' do
      expect(SendToChatgpt).to receive(:new).with('Hello').and_return(double(call: 'Hi there'))
      post :create, params: { message: 'Hello' }
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
