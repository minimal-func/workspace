class LandingController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  def index
    @app_title = 'Personal Productivity'
  end
end