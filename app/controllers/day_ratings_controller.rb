class DayRatingsController < ApplicationController
  def index
    @day_ratings = current_user.day_ratings.order(created_at: :desc)
  end
end
