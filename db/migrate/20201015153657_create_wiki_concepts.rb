class CreateWikiConcepts < ActiveRecord::Migration[6.0]
  def change
    create_table :wiki_concepts do |t|
      t.string :title
      t.text :content
      t.string :short_description
      t.integer :learning_time_minutes

      t.integer :created_by

      t.references :wiki_topic, foreign_key: true

      t.timestamps
    end
  end
end
