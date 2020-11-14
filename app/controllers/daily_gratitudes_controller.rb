class DailyGratitudesController < ApplicationController
  def index
    @daily_gratitudes = current_user.daily_gratitudes.order(created_at: :desc)
  end
end