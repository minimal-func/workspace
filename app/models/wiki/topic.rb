module Wiki
  class Topic < ApplicationRecord
    self.table_name = "wiki_topics"

    has_many :concepts, class_name: 'Wiki::Concept', foreign_key: 'wiki_topic_id', dependent: :destroy
  
    has_many :topic_subscriptions, class_name: 'Wiki::TopicSubscription', dependent: :destroy, foreign_key: 'wiki_topic_id'
    has_many :users, through: :topic_subscriptions
  
    belongs_to :creator, class_name: 'User', foreign_key: :created_by
  
    has_one_attached :featured_image, dependent: :destroy
  
    validates :featured_image, presence: true
    validates :short_description, presence: true
    validates :name, presence: true
  end
end