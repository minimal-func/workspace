class LandingController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  def index
    if user_signed_in?
      redirect_to dashboards_path
    end

    @app_title = 'Personal Productivity'
  end
end