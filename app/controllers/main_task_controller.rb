class MainTaskController < ApplicationController
  def new
    @main_task = current_user.main_task || MainTask.new
  end

  def create
    main_task = current_user.main_task

    if main_task
      if main_task.update(main_task_params)
        return redirect_to dashboards_url
      end
    else
      new_task = current_user.build_main_task(main_task_params)
      if new_task.save
        return redirect_to dashboards_url
      end
    end

    render :new
  end

  private

  def main_task_params
    params.require(:main_task).permit(:id,
      :name, :planned_finish
    )
  end
end
