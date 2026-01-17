class MainTask < ApplicationRecord
  include Notifiable
  validates :name, presence: true
  validates :planned_finish, presence: true

  belongs_to :user
end
