require 'rails_helper'

RSpec.describe EmbedsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
    stub_request(:get, /youtube\.com\/oembed/).to_return(status: 200, body: {}.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  describe 'POST #create' do
    it 'creates an embed and returns JSON' do
      post :create, params: { embed: { content: 'https://www.youtube.com/watch?v=test' } }, format: :json
      expect(response).to be_successful
    end
  end
end
