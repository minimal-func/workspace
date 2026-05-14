require 'rails_helper'

module Projects
  RSpec.describe MaterialsController, type: :controller do
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

      it 'assigns root materials' do
        FactoryBot.create_list(:material, 3, project: project)
        get :index, params: { project_id: project.id }
        expect(assigns(:materials).size).to eq(3)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: { project_id: project.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) { { title: 'New Material', short_description: 'Desc' } }

      it 'creates a new material' do
        expect {
          post :create, params: { project_id: project.id, material: valid_attributes }
        }.to change(Material, :count).by(1)
      end

      it 'redirects to materials path' do
        post :create, params: { project_id: project.id, material: valid_attributes }
        expect(response).to redirect_to(project_materials_path(project))
      end
    end
  end
end
