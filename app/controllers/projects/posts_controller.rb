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
      if current_user&.can_update_resource?(@project)
        # Show all posts to project owner/collaborators
        @posts = @project.posts.with_rich_text_content_and_embeds
      else
        # Show only public posts to others
        @posts = @project.posts.where(public: true).with_rich_text_content_and_embeds
      end
    end

    def show
      @project = @post.project
      
      # Check if user can view private posts
      unless @post.public || (current_user && current_user.can_update_resource?(@project))
        redirect_to project_posts_path(@project), alert: 'You do not have permission to view this private post.'
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        if current_user&.can_update_resource?(@post) && @post.update(post_params)
          format.html { redirect_to project_post_path(@project, @post), notice: 'Post was successfully updated.' }
          format.json { render json: { status: 'ok' }, status: :ok }
        else
          format.html { render :edit }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
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
      params.require(:post).permit(:title, :content, :featured_image, :short_description, :public).tap do |permitted_params|
        if params[:post][:body_json].present?
          body_json = params[:post][:body_json]
          permitted_params[:body_json] = if body_json.is_a?(String)
                                          JSON.parse(body_json)
                                        elsif body_json.respond_to?(:to_unsafe_h)
                                          body_json.to_unsafe_h
                                        else
                                          body_json
                                        end
        end
      end
    end
  end
end
