class WaitingListController < ApplicationController
  skip_before_action :authenticate_user!
  layout "onboard"

  def new
    @waiting_list_log = WaitingListLog.new
  end

  def create
    @waiting_list_log = WaitingListLog.new(waiting_list_log_params)

    if @waiting_list_log.save
      redirect_to root_path, notice: "You're on the list! We'll get in touch when a spot opens up."
    else
      render :new
    end
  end

  private

  def waiting_list_log_params
    params.require(:waiting_list_log).permit(:email)
  end
end