module Projects
  class PostsController < ApplicationController
    before_action :authenticate_user!, only: %i[new create learn]
    before_action :set_project, only: %i[new create index]

    def new
      @post = @workspace.posts.build
    end

    def create
      @post = @project.posts.build(post_params)
      @post.save!
      redirect_to project_posts_path(@project)
    end

    def index
      @posts = @project.posts.with_rich_text_content_and_embeds
    end

    def show
      @post = Post.find(params[:id])
      @workspace = @post.postable
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :featured_image, :short_description)
    end
  end
end
