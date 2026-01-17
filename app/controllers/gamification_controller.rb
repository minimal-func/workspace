class GamificationController < ApplicationController
  before_action :authenticate_user!

  def index
    @achievements = current_user.achievements.order(earned_at: :desc)
    @available_achievements = Achievement.where.not(id: @achievements.pluck(:id))
    @points = current_user.points.order(created_at: :desc).limit(10)
    @level = current_user.level
    @next_level = @level&.next_level
    @points_to_next_level = @level&.points_to_next_level(current_user.total_points) || 0
  end
end