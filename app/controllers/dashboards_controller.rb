class DashboardsController < ApplicationController
  def index
    load_dashboard
  end

  def create
    if current_user.update(user_params)
      redirect_to dashboards_url
    else
      load_dashboard
      render "index"
    end
  end

  private

  def load_dashboard
    @user = current_user
    data = DashboardData.new(@user).prepare

    @main_task = data[:main_task]
    @happiness_score = data[:happiness_score]
    @weekly_happiness_metrics = data[:weekly_happiness_metrics]
    @gratitude_days_count = data[:gratitude_days_count]
    @reflection_days_count = data[:reflection_days_count]
    @active_projects = data[:active_projects]
    @open_todos_count = data[:open_todos_count]
    @happiness_trend = data[:happiness_trend]
    @happiness_focus = data[:happiness_focus]
  end

  def user_params
    params.require(:user).permit(:id,
      today_daily_lessons_attributes: [:id, :content],
      today_daily_gratitudes_attributes: [:id, :content],
      today_reflections_attributes: [:id, :content, :body_json],
      today_biggest_challenges_attributes: [:id, :content],
      today_moods_attributes: [:id, :value, :tag_list],
      today_day_ratings_attributes: [:id, :value, :tag_list],
      today_energy_levels_attributes: [:id, :value, :tag_list]
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
