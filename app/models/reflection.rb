class Reflection < ApplicationRecord
  include Notifiable
  belongs_to :user
  has_rich_text :content

  scope :today, -> { where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day) }
end
