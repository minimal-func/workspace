class DayRatingsController < ApplicationController
  def index
    @pagy, @day_ratings = pagy(current_user.day_ratings.order(created_at: :desc), items: 30)
  end
end
