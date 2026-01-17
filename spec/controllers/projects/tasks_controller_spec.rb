require 'rails_helper'

module Timetracker
  RSpec.describe TasksController, type: :controller do
    let(:user) { FactoryBot.create(:user) }
    let(:project) { FactoryBot.create(:project, user: user) }
    let(:task) { FactoryBot.create(:task, project: project) }

    before do
      sign_in user
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index, params: { project_id: project.id }
        expect(response).to be_successful
      end

      it 'assigns the current project to @current_project' do
        get :index, params: { project_id: project.id }
        expect(assigns(:current_project)).to eq(project)
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) {
        { content: 'Test content' }
      }

      it 'creates a new task' do
        expect {
          post :create, params: { project_id: project.id, task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it 'renders a JSON response with the new task' do
        post :create, params: { project_id: project.id, task: valid_attributes }
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    describe 'POST #finish' do
      it 'updates the task' do
        post :finish, params: { task_id: task.id }
        task.reload
        expect(task.finished_at).not_to be_nil
      end

      it 'renders a JSON response with the updated task' do
        post :finish, params: { task_id: task.id }
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end