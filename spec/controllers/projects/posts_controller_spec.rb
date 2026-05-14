require 'rails_helper'

module Projects
  RSpec.describe PostsController, type: :controller do
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

      it 'assigns posts' do
        FactoryBot.create_list(:post, 3, project: project)
        get :index, params: { project_id: project.id }
        expect(assigns(:posts).size).to eq(3)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: { project_id: project.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) { { title: 'New Post', short_description: 'Desc', content: 'Content' } }

      it 'creates a new post' do
        expect {
          post :create, params: { project_id: project.id, post: valid_attributes }
        }.to change(Post, :count).by(1)
      end

      it 'redirects to posts path' do
        post :create, params: { project_id: project.id, post: valid_attributes }
        expect(response).to redirect_to(project_posts_path(project))
      end
    end

    describe 'GET #show' do
      let(:post_record) { FactoryBot.create(:post, project: project) }

      it 'returns a success response' do
        get :show, params: { project_id: project.id, id: post_record.id }
        expect(response).to be_successful
      end
    end
  end
end
