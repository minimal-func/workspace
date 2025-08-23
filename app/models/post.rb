class Post < ApplicationRecord
  belongs_to :project

  has_rich_text :content

  has_one_attached :featured_image, dependent: :destroy

  validates :short_description, presence: true
  validates :title, presence: true
  validates :public, inclusion: { in: [true, false] }
  
  # Set default value for public attribute
  after_initialize :set_default_public, if: :new_record?
  
  private
  
  def set_default_public
    self.public = false if public.nil?
  end
end
