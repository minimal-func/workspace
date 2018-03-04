class DayRating < ApplicationRecord
  validates_inclusion_of :value, in: 1..10

  scope :today, -> { where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day) }
end
