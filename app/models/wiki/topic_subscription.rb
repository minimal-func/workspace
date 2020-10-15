module Wiki
  class TopicSubscription < ApplicationRecord
    self.table_name = "wiki_topic_subscriptions"

    belongs_to :topic, class_name: 'Wiki::Topic', foreign_key: 'wiki_topic_id'
    belongs_to :user
  
  end
end  