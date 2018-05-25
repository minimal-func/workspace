class CreateWorkingTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :working_tasks do |t|
      t.text :content, null: false

      t.references :user, null: false, index: true, foreign_key: true

      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
