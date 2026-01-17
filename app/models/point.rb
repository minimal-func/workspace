class Point < ApplicationRecord
  include Notifiable
  belongs_to :user
  belongs_to :pointable, polymorphic: true, optional: true

  after_create :update_user_total_points
  after_destroy :update_user_total_points

  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :action, presence: true

  private

  def update_user_total_points
    user.update_total_points
  end
end