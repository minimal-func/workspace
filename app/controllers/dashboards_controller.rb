class DashboardsController < ApplicationController
  def index
    @user = current_user

    @user.today_reflections.first_or_initialize
    @user.today_day_ratings.first_or_initialize
    @user.today_biggest_challenges.first_or_initialize
    @user.today_daily_lessons.first_or_initialize
    @user.today_energy_levels.first_or_initialize
    @user.today_moods.first_or_initialize

    @main_task ||= current_user.main_task
  end

  def create
    if current_user.update_attributes(user_params)
      redirect_to dashboards_url
    else
      render "index"
    end
  end

  private

  def user_params
    params.require(:user).permit(:id,
      today_daily_lessons_attributes: [:id, :content],
      today_reflections_attributes: [:id, :content],
      today_biggest_challenges_attributes: [:id, :content],
      today_moods_attributes: [:id, :value],
      today_day_ratings_attributes: [:id, :value],
      today_energy_levels_attributes: [:id, :value]
    )
  end
end
