class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.text :content, null: false

      t.references :project, null: false, index: true, foreign_key: true

      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps null: false
    end
  end
end
