require 'rails_helper'

module Projects
  RSpec.describe SavedLinksController, type: :controller do
    let(:user) { FactoryBot.create(:user) }
    let(:project) { FactoryBot.create(:project, user: user) }

    before do
      sign_in user
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index, params: { project_id: project.id }
        expect(response).to be_successful
      end

      it 'assigns saved links' do
        FactoryBot.create_list(:saved_link, 3, project: project)
        get :index, params: { project_id: project.id }
        expect(assigns(:saved_links).size).to eq(3)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: { project_id: project.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) { { title: 'New Link', url: 'https://example.com' } }

      it 'creates a new saved link' do
        expect {
          post :create, params: { project_id: project.id, saved_link: valid_attributes }
        }.to change(SavedLink, :count).by(1)
      end

      it 'redirects to saved links path' do
        post :create, params: { project_id: project.id, saved_link: valid_attributes }
        expect(response).to redirect_to(project_saved_links_path(project))
      end
    end
  end
end
