module Timetracker
  class TasksController < ApplicationController
    
    # layout 'timetracker'
    
    def index
      @projects = current_user.projects
      @current_project = Project.find(params[:project_id])

      @pagy, @tasks = pagy(@current_project.tasks.order(created_at: :desc), items: 10)


      @tasks_presenter = {
        tasks: @tasks,
        form: {
          action: timetracker_project_tasks_url(@current_project.id),
          csrf_param: request_forgery_protection_token,
          csrf_token: form_authenticity_token
        }
      }
    end

    def create
      @current_project = Project.find(params[:project_id])
      task = @current_project.tasks.build(tasks_params)
      task.started_at = DateTime.current
      task.save

      render json: task
    end

    def finish
      @task = Task.find(params[:task_id])

      @task.update(finished_at: DateTime.current)

      render json: @task
    end

    private

    def tasks_params
      params.require(:task).permit(:id, :content, :project_id)
    end
  end
end
