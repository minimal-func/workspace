class SavedLink < ApplicationRecord
  include Notifiable
  validates :title, presence: true
  validates :url, presence: true

  belongs_to :project
end
