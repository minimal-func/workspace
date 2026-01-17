class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :short_description, null: false
      t.text :content
      t.boolean :public, default: false

      t.references :project, index: true, null: false, foreign_key: true
      t.timestamps
    end
  end
end
