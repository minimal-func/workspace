require 'rails_helper'

module Projects
  RSpec.describe PostImagesController, type: :controller do
    let(:user) { FactoryBot.create(:user) }
    let(:project) { FactoryBot.create(:project, user: user) }
    let(:post_record) { FactoryBot.create(:post, project: project) }

    before do
      sign_in user
    end

    describe 'POST #create' do
      it 'returns JSON with success status' do
        file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test.png'), 'image/png')
        post :create, params: { project_id: project.id, post_id: post_record.id, image: file }
        json = JSON.parse(response.body)
        expect(json['success']).to eq(1)
      end
    end

    describe 'POST #fetch_url' do
      it 'returns JSON with the provided URL' do
        post :fetch_url, params: { project_id: project.id, post_id: post_record.id, url: 'https://example.com/image.png' }
        json = JSON.parse(response.body)
        expect(json['success']).to eq(1)
        expect(json['file']['url']).to eq('https://example.com/image.png')
      end
    end
  end
end
