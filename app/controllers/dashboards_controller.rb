class DashboardsController < ApplicationController
  def index
    prepare_dashboard
  end

  def create
    if current_user.update(user_params)
      redirect_to dashboards_url
    else
      prepare_dashboard
      render "index"
    end
  end

  private

  def prepare_dashboard
    @user = current_user

    @user.today_reflections.first_or_initialize
    @user.today_day_ratings.first_or_initialize
    @user.today_biggest_challenges.first_or_initialize
    @user.today_daily_lessons.first_or_initialize
    @user.today_daily_gratitudes.first_or_initialize
    @user.today_energy_levels.first_or_initialize
    @user.today_moods.first_or_initialize

    @main_task ||= current_user.main_task

    recent_range = 6.days.ago.beginning_of_day..Time.current.end_of_day
    recent_moods = @user.moods.where(created_at: recent_range)
    recent_day_ratings = @user.day_ratings.where(created_at: recent_range)
    recent_energy_levels = @user.energy_levels.where(created_at: recent_range)

    @happiness_score = [
      average_value(recent_moods),
      average_value(recent_day_ratings),
      average_value(recent_energy_levels)
    ].compact.sum.fdiv(3).round(1)

    @weekly_happiness_metrics = [
      { label: "Mood", value: average_value(recent_moods), theme: "sun" },
      { label: "Alignment", value: average_value(recent_day_ratings), theme: "sea" },
      { label: "Energy", value: average_value(recent_energy_levels), theme: "leaf" }
    ]

    @gratitude_days_count = @user.daily_gratitudes.where(created_at: recent_range)
      .distinct.count("DATE(created_at)")
    @reflection_days_count = @user.reflections.where(created_at: recent_range)
      .distinct.count("DATE(created_at)")

    @happiness_trend = happiness_trend_for(recent_moods)
    @happiness_focus = happiness_focus_for(
      mood: average_value(recent_moods),
      alignment: average_value(recent_day_ratings),
      energy: average_value(recent_energy_levels)
    )
  end

  def average_value(records)
    return 0.0 if records.empty?

    records.average(:value).to_f.round(1)
  end

  def happiness_trend_for(recent_moods)
    recent_values = recent_moods.order(created_at: :asc).pluck(:value)
    return "Start logging your mood to uncover what reliably makes your days better." if recent_values.size < 3

    midpoint = recent_values.size / 2
    first_half = recent_values.first(midpoint)
    second_half = recent_values.last(recent_values.size - midpoint)
    difference = (second_half.sum.fdiv(second_half.size)) - (first_half.sum.fdiv(first_half.size))

    if difference >= 0.5
      "Your mood is trending upward this week. Keep protecting the habits that are working."
    elsif difference <= -0.5
      "Your mood dipped this week. Reduce pressure and lean on small restorative routines tomorrow."
    else
      "Your mood is stable this week. Small gains in sleep, gratitude, and focus should move it upward."
    end
  end

  def happiness_focus_for(mood:, alignment:, energy:)
    lowest_area, lowest_value = {
      "mood" => mood,
      "alignment" => alignment,
      "energy" => energy
    }.min_by { |_area, value| value }

    return "You do not have enough check-ins yet. Start with one honest daily entry and build from there." if lowest_value.zero?

    case lowest_area
    when "mood"
      "Mood is your biggest opportunity. Use the reflection and gratitude prompts to notice what genuinely lifted you."
    when "alignment"
      "Alignment is lagging. Narrow tomorrow to one meaningful challenge so progress feels clearer and lighter."
    else
      "Energy is the main constraint. A happier day tomorrow probably starts with recovery, not more ambition."
    end
  end

  def user_params
    params.require(:user).permit(:id,
      today_daily_lessons_attributes: [:id, :content],
      today_daily_gratitudes_attributes: [:id, :content],
      today_reflections_attributes: [:id, :content, :body_json],
      today_biggest_challenges_attributes: [:id, :content],
      today_moods_attributes: [:id, :value],
      today_day_ratings_attributes: [:id, :value],
      today_energy_levels_attributes: [:id, :value]
    ).tap do |permitted_params|
      if permitted_params[:today_reflections_attributes].present?
        permitted_params[:today_reflections_attributes].each do |index, reflection_params|
          next if reflection_params.nil?
          if reflection_params[:body_json].present? && reflection_params[:body_json].is_a?(String)
            permitted_params[:today_reflections_attributes][index][:body_json] = JSON.parse(reflection_params[:body_json])
          end
        end
      end
    end
  end
end
