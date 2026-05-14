require 'rails_helper'

module Timetracker
  RSpec.describe ProjectsController, type: :controller do
    let(:user) { FactoryBot.create(:user) }

    before do
      sign_in user
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns active and closed projects' do
        FactoryBot.create(:project, user: user, closed: false)
        FactoryBot.create(:project, user: user, closed: true)
        get :index
        expect(assigns(:active_projects).size).to eq(1)
        expect(assigns(:closed_projects).size).to eq(1)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      it 'creates a new project' do
        expect {
          post :create, params: { project: { title: 'New Project' } }
        }.to change(Project, :count).by(1)
      end

      it 'redirects to project tasks' do
        post :create, params: { project: { title: 'New Project' } }
        expect(response).to redirect_to(timetracker_project_tasks_url(assigns(:project)))
      end

      context 'when project belongs to the current user' do
        it 'assigns the project to the current user' do
          post :create, params: { project: { title: 'New Project' } }
          expect(assigns(:project).user).to eq(user)
        end
      end
    end

    describe 'POST #close' do
      let(:project) { FactoryBot.create(:project, user: user, closed: false) }

      it 'closes the project' do
        post :close, params: { project_id: project.id }
        expect(project.reload.closed).to be true
      end

      it 'redirects to projects list' do
        post :close, params: { project_id: project.id }
        expect(response).to redirect_to(timetracker_projects_url)
      end
    end

    describe 'POST #open' do
      let(:project) { FactoryBot.create(:project, user: user, closed: true) }

      it 'opens the project' do
        post :open, params: { project_id: project.id }
        expect(project.reload.closed).to be false
      end
    end

    describe 'DELETE #destroy' do
      let!(:project) { FactoryBot.create(:project, user: user) }

      it 'destroys the project' do
        expect {
          delete :destroy, params: { id: project.id }
        }.to change(Project, :count).by(-1)
      end
    end
  end
end
