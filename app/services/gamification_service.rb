class GamificationService
  POINT_VALUES = {
    create_project: 50,
    create_task: 10,
    complete_task: 20,
    create_post: 30,
    create_todo: 10,
    complete_todo: 20,
    create_saved_link: 10,
    create_material: 20
  }.freeze

  def self.award_points_for(action, user, resource = nil)
    return unless user && POINT_VALUES.key?(action.to_sym)
    
    points = POINT_VALUES[action.to_sym]
    user.award_points(points, action.to_s, resource)
    check_action_achievements(action, user)
  end

  def self.check_action_achievements(action, user)
    action_type = action.to_s.start_with?('create_') ? "#{action.to_s.sub('create_', '')}_created" : "#{action.to_s.sub('complete_', '')}_completed"
    
    # Find achievements related to this action type
    Achievement.where(achievement_type: action_type).each do |achievement|
      # Count how many times the user has performed this action
      count = user.points.where(action: action.to_s).count
      
      # Award achievement if threshold is met
      if count >= achievement.threshold && !user.achievements.include?(achievement)
        achievement.award_to(user)
      end
    end
  end
end