require 'rails_helper'

module Projects
  RSpec.describe TodosController, type: :controller do
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

      it 'assigns todos' do
        FactoryBot.create_list(:todo, 3, project: project)
        get :index, params: { project_id: project.id }
        expect(assigns(:todos).size).to eq(3)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: { project_id: project.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) { { name: 'New Todo' } }

      it 'creates a new todo' do
        expect {
          post :create, params: { project_id: project.id, todo: valid_attributes }
        }.to change(Todo, :count).by(1)
      end

      it 'redirects to todos path' do
        post :create, params: { project_id: project.id, todo: valid_attributes }
        expect(response).to redirect_to(project_todos_path(project))
      end
    end

    describe 'PATCH #update' do
      let(:todo) { FactoryBot.create(:todo, project: project, name: 'Old name') }

      it 'updates the todo' do
        patch :update, params: { project_id: project.id, id: todo.id, todo: { name: 'Updated' } }
        expect(todo.reload.name).to eq('Updated')
      end
    end

    describe 'DELETE #destroy' do
      let!(:todo) { FactoryBot.create(:todo, project: project) }

      it 'destroys the todo' do
        expect {
          delete :destroy, params: { project_id: project.id, id: todo.id }
        }.to change(Todo, :count).by(-1)
      end
    end
  end
end
