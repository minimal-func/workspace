class Post < ApplicationRecord
  include Notifiable
  belongs_to :project

  has_rich_text :content

  has_one_attached :featured_image, dependent: :destroy

  validates :short_description, presence: true
  validates :title, presence: true
  validates :public, inclusion: { in: [true, false] }
  
  # Set default value for public attribute
  after_initialize :set_default_public, if: :new_record?

  def self.ransackable_attributes(_auth_object = nil)
    ["body_json", "content", "created_at", "id", "id_value", "project_id", "public", "short_description", "title", "updated_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["project"]
  end
  
  private
  
  def set_default_public
    self.public = false if public.nil?
  end
end
