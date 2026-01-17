class UserAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  validates :user_id, uniqueness: { scope: :achievement_id, message: "has already earned this achievement" }

  before_create :set_earned_at

  private

  def set_earned_at
    self.earned_at ||= Time.current
  end
end