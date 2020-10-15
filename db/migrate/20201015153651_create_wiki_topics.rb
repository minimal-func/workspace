class CreateWikiTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :wiki_topics do |t|
      t.string :name
      t.string :short_description
      t.integer :created_by

      t.timestamps
    end
  end
end
