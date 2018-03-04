class DailyLessonsController < ApplicationController
  def index
    @daily_lessons = current_user.daily_lessons
  end
end
