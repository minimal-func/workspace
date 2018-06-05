class CreateMainTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :main_tasks do |t|
      t.string :name, required: true
      t.datetime :planned_finish, required: true

      t.references :user, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
