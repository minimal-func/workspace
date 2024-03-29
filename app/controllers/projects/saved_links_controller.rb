module Projects
  class SavedLinksController < ApplicationController
    before_action :authenticate_user!, only: %i[new create index]
    before_action :set_project, only: %i[new create index]
    def new
      @saved_link = @project.saved_links.build
    end

    def create
      @saved_link = @project.saved_links.build(saved_link_params)
      @saved_link.save!
      redirect_to project_saved_links_path(@project)
    end

    def index
      @saved_links = @project.saved_links
    end

    def show
      @saved_link = SavedLink.find(params[:id])
      @workspace = @saved_link.project
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def saved_link_params
      params.require(:saved_link).permit(:title, :short_description, :url)
    end
  end
end
