class Material < ApplicationRecord
  validates :title, presence: true

  has_one_attached :file, dependent: :destroy

  belongs_to :project
end
