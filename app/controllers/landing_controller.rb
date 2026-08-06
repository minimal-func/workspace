class LandingController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :help]
  
  def index
    @app_title = 'Personal Productivity'
  end

  def help
    @app_title = 'Help'
  end
end
