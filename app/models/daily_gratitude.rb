class DailyGratitude < ApplicationRecord
  include Notifiable
  belongs_to :user

  scope :today, -> { where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day) }
end