class Post < ApplicationRecord
  belongs_to :project

  has_rich_text :content

  has_one_attached :featured_image, dependent: :destroy

  validates :short_description, presence: true
  validates :title, presence: true
end
