module Projects
  class PostsController < ApplicationController
    before_action :authenticate_user!, only: %i[new create edit update learn]
    before_action :set_project, only: %i[new create index edit update]
    before_action :set_post, only: %i[show edit update]

    def new
      @post = @project.posts.build
    end

    def create
      @post = @project.posts.build(post_params)

      if @post.save
        # Award points for creating a post
        GamificationService.award_points_for(:create_post, current_user, @post) if current_user
        redirect_to project_posts_path(@project), notice: 'Post was successfully created.'
      else
        render :new
      end
    end

    def index
      @posts = @project.posts.with_rich_text_content_and_embeds
    end

    def show
      @project = @post.project
    end

    def edit
    end

    def update
      if can_update_resource?(@post) && @post.update(post_params)
        redirect_to project_post_path(@project, @post), notice: 'Post was successfully updated.'
      else
        render :edit
      end
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :featured_image, :short_description)
    end
  end
end
