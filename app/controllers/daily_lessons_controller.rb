class DailyLessonsController < ApplicationController
  def index
    @daily_lessons = current_user.daily_lessons.order(created_at: :desc)
  end
end
