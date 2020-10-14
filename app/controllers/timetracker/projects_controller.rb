module Timetracker
  class ProjectsController < ApplicationController

    # layout 'timetracker'

    def index
      @projects = current_user.projects
    end

    def new
      @project = Project.new
    end

    def create
      @project = current_user.projects.create(project_params)
      redirect_to timetracker_project_tasks_url(@project)
    end

    private

    def project_params
      params.require(:project).permit(:title)
    end

  end
end
