class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :set_app_title

  include Pagy::Backend

  helper_method :turbo_native_app?

  def turbo_native_app?
    request.user_agent&.include?("MyDayTurboNative")
  end

  def set_app_title
    @app_title = 'Diary'
  end
end
