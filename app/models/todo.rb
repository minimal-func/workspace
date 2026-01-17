class Todo < ApplicationRecord
  include Notifiable
  validates :name, presence: true

  belongs_to :project
end
