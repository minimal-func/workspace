class SavedLink < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true

  belongs_to :project
end
