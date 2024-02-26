class Project < ApplicationRecord
  validates :title, presence: true, allow_blank: false

  belongs_to :user
  has_many :tasks, dependent: :destroy

  has_many :todos, dependent: :destroy
  has_many :posts, as: :postable, dependent: :destroy
  has_many :saved_links, dependent: :destroy
  has_many :materials, dependent: :destroy
end
