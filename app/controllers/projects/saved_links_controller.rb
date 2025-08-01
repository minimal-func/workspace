module Projects
  class SavedLinksController < ApplicationController
    before_action :authenticate_user!, only: %i[new create index edit update]
    before_action :set_project, only: %i[new create index]
    before_action :set_saved_link, only: %i[show edit update]

    def new
      @saved_link = @project.saved_links.build
    end

    def create
      @saved_link = @project.saved_links.build(saved_link_params)
      @saved_link.save!
      
      # Award points for creating a saved link
      GamificationService.award_points_for(:create_saved_link, current_user, @saved_link) if current_user
      
      redirect_to project_saved_links_path(@project)
    end

    def index
      @saved_links = @project.saved_links
    end

    def show
      @project = @saved_link.project
    end

    def edit
      @project = @saved_link.project
    end

    def update
      @project = @saved_link.project
      if can_update_resource?(@saved_link) && @saved_link.update(saved_link_params)
        redirect_to project_saved_links_path(@project), notice: 'Saved link was successfully updated.'
      else
        render :edit
      end
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_saved_link
      @saved_link = SavedLink.find(params[:id])
    end

    def saved_link_params
      params.require(:saved_link).permit(:title, :short_description, :url)
    end
  end
end
