class DashboardsController < ApplicationController
  def index
    @user = current_user

    @user.today_reflections.first_or_initialize
    @user.today_day_ratings.first_or_initialize
    @user.today_biggest_challenges.first_or_initialize
    @user.today_daily_lessons.first_or_initialize
    @user.today_daily_gratitudes.first_or_initialize
    @user.today_energy_levels.first_or_initialize
    @user.today_moods.first_or_initialize

    @main_task ||= current_user.main_task
  end

  def create
    if current_user.update(user_params)
      redirect_to dashboards_url
    else
      render "index"
    end
  end

  private

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
