class MainTaskController < ApplicationController
  def new
    @main_task = current_user.main_task || MainTask.new
  end

  def create
    main_task = current_user.main_task

    return redirect_to dashboards_url if main_task && main_task.update!(main_task_params)
    return redirect_to dashboards_url if !main_task && current_user.create_main_task(main_task_params)

    render :new
  end

  private

  def main_task_params
    params.require(:main_task).permit(:id,
      :name, :planned_finish
    )
  end
end
