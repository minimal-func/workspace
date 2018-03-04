class DayRatingsController < ApplicationController
  def index
    @day_ratings = current_user.day_ratings
  end
end
