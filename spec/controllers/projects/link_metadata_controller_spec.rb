require 'rails_helper'

module Projects
  RSpec.describe LinkMetadataController, type: :controller do
    let(:user) { FactoryBot.create(:user) }

    before do
      sign_in user
    end

    describe 'GET #fetch' do
      it 'returns success 0 for blank URL' do
        get :fetch, params: { url: '' }
        json = JSON.parse(response.body)
        expect(json['success']).to eq(0)
      end
    end
  end
end
