class WorkingTasksController < ApplicationController
  def index
    @working_tasks_presenter = {
      tasks: current_user.working_tasks,
      form: {
        action: working_tasks_url,
        csrf_param: request_forgery_protection_token,
        csrf_token: form_authenticity_token
      }
    }
  end

  def create
    working_task = current_user.working_tasks.build(working_tasks_params)
    working_task.started_at = DateTime.current
    working_task.save

    render json: working_task
  end

  def finish
    @working_task = WorkingTask.find(params[:working_task_id])

    @working_task.update(finished_at: DateTime.current)

    render json: @working_task
  end

  private

  def working_tasks_params
    params.require(:working_task).permit(:id, :content)
  end
end
