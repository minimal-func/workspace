class Achievement < ApplicationRecord
  has_many :user_achievements, dependent: :destroy
  has_many :users, through: :user_achievements

  validates :name, presence: true, uniqueness: true
  validates :points_required, numericality: { greater_than_or_equal_to: 0 }
  validates :threshold, numericality: { greater_than: 0 }

  # Achievement types
  TYPES = {
    points: 'points',
    tasks_completed: 'tasks_completed',
    posts_created: 'posts_created',
    todos_completed: 'todos_completed',
    materials_uploaded: 'materials_uploaded',
    links_saved: 'links_saved',
    projects_created: 'projects_created'
  }.freeze

  # Check if a user has earned this achievement
  def earned_by?(user)
    user_achievements.exists?(user: user)
  end

  # Award this achievement to a user
  def award_to(user)
    return if earned_by?(user)
    
    user_achievements.create!(user: user, earned_at: Time.current)
    user.notifications.create!(
      message: "You've earned the achievement: #{name}!",
      notifiable: self
    )
  end
end