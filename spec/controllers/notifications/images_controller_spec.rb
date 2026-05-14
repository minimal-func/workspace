require 'rails_helper'

module Notifications
  RSpec.describe ImagesController, type: :controller do
    let(:user) { FactoryBot.create(:user) }

    before do
      sign_in user
    end

    describe 'POST #create' do
      it 'returns JSON with success status' do
        file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test.png'), 'image/png')
        post :create, params: { image: file }
        expect(response.content_type).to eq('application/json; charset=utf-8')
        json = JSON.parse(response.body)
        expect(json['success']).to eq(1)
      end
    end

    describe 'POST #fetch_url' do
      it 'returns JSON with the provided URL' do
        post :fetch_url, params: { url: 'https://example.com/image.png' }
        json = JSON.parse(response.body)
        expect(json['success']).to eq(1)
        expect(json['file']['url']).to eq('https://example.com/image.png')
      end
    end
  end
end
