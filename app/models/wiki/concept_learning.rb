module Wiki
  class ConceptLearning < ApplicationRecord
    self.table_name = "wiki_concept_learnings"

    belongs_to :concept, class_name: 'Wiki::Concept', foreign_key: 'wiki_concept_id'
    belongs_to :user
  
  end  
end