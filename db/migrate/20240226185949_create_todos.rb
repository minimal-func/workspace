class CreateTodos < ActiveRecord::Migration[7.1]
  def change
    create_table :todos do |t|
      t.string :name, null: false

      t.references :project, null: false, index: true, foreign_key: true
      t.boolean :finished, default: false
      t.timestamps
    end
  end
end
