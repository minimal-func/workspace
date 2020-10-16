module Wiki
  class Concept < ApplicationRecord
    self.table_name = "wiki_concepts"

    belongs_to :topic, class_name: 'Wiki::Topic', foreign_key: 'wiki_topic_id'
  
    has_many :concept_learnings, class_name: 'Wiki::ConceptLearning', foreign_key: 'wiki_concept_id', dependent: :destroy
    has_many :users, through: :concept_learnings
  
    has_rich_text :content
  
    has_one_attached :featured_image, dependent: :destroy
  
    validates :featured_image, presence: true
    validates :learning_time_minutes, presence: true
    validates :short_description, presence: true
    validates :title, presence: true
  end
end