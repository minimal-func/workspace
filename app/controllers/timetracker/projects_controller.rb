module Timetracker
  class ProjectsController < ApplicationController

    before_action :set_app_title

    def index
      projects = current_user.projects

      @active_projects = projects.where(closed: false)
      @closed_projects = projects.where(closed: true)
    end

    def new
      @project = Project.new
    end

    def create
      @project = current_user.projects.create(project_params)
      
      # Award points for creating a project
      GamificationService.award_points_for(:create_project, current_user, @project) if current_user
      
      redirect_to timetracker_project_tasks_url(@project)
    end

    def close
      @project = current_user.projects.find(params[:project_id])
      @project.update(closed: true)
      redirect_to timetracker_projects_url
    end

    def open
      @project = current_user.projects.find(params[:project_id])
      @project.update(closed: false)
      redirect_to timetracker_projects_url
    end

    def destroy
      @project = current_user.projects.find(params[:id])
      @project.destroy
      redirect_to timetracker_projects_url
    end

    private

    def project_params
      params.require(:project).permit(:title)
    end

    def set_app_title
      @app_title = 'Timetracker'
    end
  end
end
