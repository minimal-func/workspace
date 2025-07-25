class DailyGratitudesController < ApplicationController
  def index
    @pagy, @daily_gratitudes = pagy(current_user.daily_gratitudes.order(created_at: :desc), items: 10)
  end
end