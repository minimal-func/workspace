class Project < ApplicationRecord
  validates :title, presence: true, allow_blank: false

  belongs_to :user
  has_many :tasks
end
