class RootController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if user_signed_in?
      redirect_to dashboards_path
    else
      redirect_to landing_path
    end
  end
end
