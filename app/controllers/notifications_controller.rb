class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.recent
  end

  def update
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read!

    respond_to do |format|
      format.html { redirect_back fallback_location: notifications_path }
      format.js
    end
  end
end
