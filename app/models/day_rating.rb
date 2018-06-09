class DayRating < ApplicationRecord
  belongs_to :user

  validates :value, presence: true
  validates_inclusion_of :value, in: 1..10

  scope :today, -> { where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day) }
end
