class LogsController < ApplicationController
  def index
    reflections = current_user.reflections
    day_ratings = current_user.day_ratings
    biggest_challenges = current_user.biggest_challenges
    daily_lessons = current_user.daily_lessons
  end
end
