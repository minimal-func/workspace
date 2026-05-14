require 'rails_helper'

RSpec.describe MainTaskController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new main task' do
      get :new
      expect(assigns(:main_task)).to be_a_new(MainTask)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { name: 'My main task', planned_finish: Date.tomorrow } }

    it 'creates a new main task' do
      expect {
        post :create, params: { main_task: valid_attributes }
      }.to change(MainTask, :count).by(1)
    end

    it 'redirects to dashboards url' do
      post :create, params: { main_task: valid_attributes }
      expect(response).to redirect_to(dashboards_url)
    end

    context 'when updating existing task' do
      let!(:main_task) { FactoryBot.create(:main_task, user: user, name: 'Old task') }

      it 'updates the existing task' do
        post :create, params: { main_task: valid_attributes }
        expect(main_task.reload.name).to eq('My main task')
      end
    end
  end
end
