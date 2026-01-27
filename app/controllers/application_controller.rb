class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :set_app_title
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pagy::Backend

  helper_method :turbo_native_app?

  def turbo_native_app?
    request.user_agent&.include?("MyDayTurboNative")
  end

  def set_app_title
    @app_title = 'Diary'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:eth_wallet_address])
  end
end
