class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :set_app_title

  include Pagy::Backend

  helper_method :turbo_native_app?, :feature_unlocked?, :feature_name, :feature_unlock_level, :feature_purchase_cost, :feature_can_be_purchased?, :project_feature_unlocked?, :project_feature_name, :project_feature_unlock_level

  protected

  def authenticate_user!
    return if admin_controller?

    super
  end

  private

  def admin_controller?
    controller_path.split("/").first == "admin"
  end

  def turbo_native_app?
    request.user_agent&.include?("MyDayTurboNative")
  end

  def feature_unlocked?(feature)
    current_user&.feature_unlocked?(feature) || false
  end

  def feature_purchase_cost(feature)
    current_user&.feature_purchase_cost(feature)
  end

  def feature_can_be_purchased?(feature)
    current_user&.can_purchase_feature?(feature) || false
  end

  def feature_name(feature)
    User.feature_name(feature)
  end

  def feature_unlock_level(feature)
    User.feature_unlock_level(feature)
  end

  def project_feature_unlocked?(feature)
    feature_unlocked?(feature)
  end

  def project_feature_name(feature)
    feature_name(feature)
  end

  def project_feature_unlock_level(feature)
    feature_unlock_level(feature)
  end

  def require_feature_level(feature)
    return if feature_unlocked?(feature)

    redirect_to gamification_path, alert: "Reach Level #{feature_unlock_level(feature)} to unlock #{feature_name(feature)}."
  end

  def require_project_feature_level(feature)
    require_feature_level(feature)
  end

  def set_app_title
    @app_title = 'Diary'
  end
end
