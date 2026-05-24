class DashboardData
  RECENT_DAYS = 6

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def prepare
    {
      today_reflection: user.today_reflections.first_or_initialize,
      today_day_rating: user.today_day_ratings.first_or_initialize,
      today_biggest_challenge: user.today_biggest_challenges.first_or_initialize,
      today_daily_lesson: user.today_daily_lessons.first_or_initialize,
      today_daily_gratitude: user.today_daily_gratitudes.first_or_initialize,
      today_energy_level: user.today_energy_levels.first_or_initialize,
      today_mood: user.today_moods.first_or_initialize,
      main_task: user.main_task,
      happiness_score: happiness_score,
      weekly_happiness_metrics: weekly_happiness_metrics,
      gratitude_days_count: gratitude_days_count,
      reflection_days_count: reflection_days_count,
      active_projects: active_projects,
      open_todos_count: open_todos_count,
      happiness_trend: happiness_trend,
      happiness_focus: happiness_focus
    }
  end

  private

  def recent_range
    RECENT_DAYS.days.ago.beginning_of_day..Time.current.end_of_day
  end

  def recent_moods
    @recent_moods ||= user.moods.where(created_at: recent_range)
  end

  def recent_day_ratings
    @recent_day_ratings ||= user.day_ratings.where(created_at: recent_range)
  end

  def recent_energy_levels
    @recent_energy_levels ||= user.energy_levels.where(created_at: recent_range)
  end

  def happiness_score
    values = [
      average_value(recent_moods),
      average_value(recent_day_ratings),
      average_value(recent_energy_levels)
    ].compact
    return 0.0 if values.empty?
    values.sum.fdiv(3).round(1)
  end

  def weekly_happiness_metrics
    [
      { label: "Mood", value: average_value(recent_moods), theme: "sun" },
      { label: "Alignment", value: average_value(recent_day_ratings), theme: "sea" },
      { label: "Energy", value: average_value(recent_energy_levels), theme: "leaf" }
    ]
  end

  def gratitude_days_count
    user.daily_gratitudes.where(created_at: recent_range)
      .distinct.count("DATE(created_at)")
  end

  def reflection_days_count
    user.reflections.where(created_at: recent_range)
      .distinct.count("DATE(created_at)")
  end

  def active_projects
    user.projects.includes(:todos).order(id: :desc).limit(3)
  end

  def open_todos_count
    user.projects.joins(:todos).where(todos: { finished: false }).count
  end

  def happiness_trend
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

  def happiness_focus
    mood_val = average_value(recent_moods)
    alignment_val = average_value(recent_day_ratings)
    energy_val = average_value(recent_energy_levels)

    lowest_area, lowest_value = {
      "mood" => mood_val,
      "alignment" => alignment_val,
      "energy" => energy_val
    }.min_by { |_, value| value }

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

  def average_value(records)
    return 0.0 if records.empty?
    records.average(:value).to_f.round(1)
  end
end