class CreateSavedLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_links do |t|
      t.string :title, null: false
      t.text :short_description
      t.string :url, null: false

      t.references :project, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end
