class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :set_app_title

  include Pagy::Backend

  def set_app_title
    @app_title = 'Diary'
  end
end
