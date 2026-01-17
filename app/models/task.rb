class Task < ApplicationRecord
  include Notifiable
  validates :content, presence: true, allow_blank: false

  belongs_to :project
end
