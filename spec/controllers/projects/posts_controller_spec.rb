require 'rails_helper'

module Projects
  RSpec.describe PostsController, type: :controller do
    let(:user) { FactoryBot.create(:user) }
    let(:project) { FactoryBot.create(:project, user: user) }

    before do
      sign_in user
    end

    describe 'GET #index' do
      context 'when the user has not reached the Posts unlock level' do
        let!(:level1) { FactoryBot.create(:level, level_number: 1, points_required: 0, name: 'Beginner') }
 
        before do
          user.update(level: level1, total_points: 0)
        end
 
        it 'redirects to the gamification page' do
          get :index, params: { project_id: project.id }
          expect(response).to redirect_to(gamification_path)
          expect(flash[:alert]).to include('Reach Level')
        end
      end
 
      context 'when the user has reached the Posts unlock level' do
        let!(:level3) { FactoryBot.create(:level, level_number: 3, points_required: 300, name: 'Enthusiast') }
 
        before do
          user.update(level: level3, total_points: 300)
        end
 
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
    end

    describe 'GET #new' do
      context 'when the user has reached the Posts unlock level' do
        let!(:level3) { FactoryBot.create(:level, level_number: 3, points_required: 300, name: 'Enthusiast') }

        before do
          user.update(level: level3, total_points: 300)
        end

        it 'returns a success response' do
          get :new, params: { project_id: project.id }
          expect(response).to be_successful
        end
      end

      context 'when the user has not reached the Posts unlock level' do
        let!(:level1) { FactoryBot.create(:level, level_number: 1, points_required: 0, name: 'Beginner') }

        before do
          user.update(level: level1, total_points: 0)
        end

        it 'redirects to the gamification page' do
          get :new, params: { project_id: project.id }
          expect(response).to redirect_to(gamification_path)
          expect(flash[:alert]).to include('Reach Level')
        end
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) { { title: 'New Post', short_description: 'Desc', content: 'Content' } }

      context 'when the user has reached the Posts unlock level' do
        let!(:level3) { FactoryBot.create(:level, level_number: 3, points_required: 300, name: 'Enthusiast') }

        before do
          user.update(level: level3, total_points: 300)
        end

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

      context 'when the user has not reached the Posts unlock level' do
        let!(:level1) { FactoryBot.create(:level, level_number: 1, points_required: 0, name: 'Beginner') }

        before do
          user.update(level: level1, total_points: 0)
        end

        it 'does not create a post and redirects to the gamification page' do
          expect {
            post :create, params: { project_id: project.id, post: valid_attributes }
          }.not_to change(Post, :count)
          expect(response).to redirect_to(gamification_path)
          expect(flash[:alert]).to include('Reach Level')
        end
      end
    end

    describe 'GET #show' do
      let(:post_record) { FactoryBot.create(:post, project: project) }

      context 'when the user has reached the Posts unlock level' do
        let!(:level3) { FactoryBot.create(:level, level_number: 3, points_required: 300, name: 'Enthusiast') }

        before do
          user.update(level: level3, total_points: 300)
        end

        it 'returns a success response' do
          get :show, params: { project_id: project.id, id: post_record.id }
          expect(response).to be_successful
        end
      end

      context 'when the user has not reached the Posts unlock level' do
        let!(:level1) { FactoryBot.create(:level, level_number: 1, points_required: 0, name: 'Beginner') }

        before do
          user.update(level: level1, total_points: 0)
        end

        it 'redirects to the gamification page' do
          get :show, params: { project_id: project.id, id: post_record.id }
          expect(response).to redirect_to(gamification_path)
          expect(flash[:alert]).to include('Reach Level')
        end
      end
    end
  end
end
