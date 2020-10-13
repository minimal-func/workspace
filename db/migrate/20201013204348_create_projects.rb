class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.references :user, null: false, index: true, foreign_key: true
    end
  end
end
