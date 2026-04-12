class GamificationController < ApplicationController
  before_action :authenticate_user!

  def index
    @achievements = current_user.achievements.order(earned_at: :desc)
    @available_achievements = Achievement.where.not(id: @achievements.pluck(:id))
    @points = current_user.points.order(created_at: :desc).limit(10)
    @level = current_user.level
    @next_level = @level&.next_level
    @points_to_next_level = @level&.points_to_next_level(current_user.total_points) || 0
    @level_progress_percentage = level_progress_percentage
    @mascot_headline = mascot_headline
    @mascot_message = mascot_message
    @mascot_focus = mascot_focus
  end

  private

  def level_progress_percentage
    return 0 unless @level && @next_level

    current_points = current_user.total_points - @level.points_required
    level_span = @next_level.points_required - @level.points_required
    return 100 if level_span <= 0

    ((current_points.to_f / level_span) * 100).clamp(0, 100).round
  end

  def mascot_headline
    return "Sunny is ready for your first streak" unless @level
    return "Sunny says you're at the top tier" unless @next_level

    "Sunny is tracking your next level-up"
  end

  def mascot_message
    return "Earn your first points to wake up the reward loop. A single completed action is enough to get started." if @points.empty?
    return "You're holding Level #{@level.level_number}, #{@level.name}. Every new action now is pure momentum." if @level && @next_level.blank?

    recent_action = @points.first&.action&.humanize&.downcase
    "You just earned momentum from #{recent_action}. Keep going and Sunny will cheer you into #{@next_level.name} in #{@points_to_next_level} more points."
  end

  def mascot_focus
    achievement = @available_achievements.order(:threshold, :name).first
    return "All achievements unlocked. Sunny approves." unless achievement

    "Next unlock: #{achievement.name}"
  end
end
