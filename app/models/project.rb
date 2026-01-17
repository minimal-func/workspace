class Project < ApplicationRecord
  include Notifiable
  validates :title, presence: true, allow_blank: false

  belongs_to :user
  has_many :tasks, dependent: :destroy

  has_many :todos, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :saved_links, dependent: :destroy
  has_many :materials, dependent: :destroy
end
