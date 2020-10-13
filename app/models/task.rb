class Task < ApplicationRecord
  validates :content, presence: true, allow_blank: false

  belongs_to :project
end
