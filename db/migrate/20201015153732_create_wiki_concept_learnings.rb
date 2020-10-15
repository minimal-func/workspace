class CreateWikiConceptLearnings < ActiveRecord::Migration[6.0]
  def change
    create_table :wiki_concept_learnings do |t|
      t.references :wiki_concept, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
