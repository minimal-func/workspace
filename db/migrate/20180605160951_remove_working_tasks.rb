class RemoveWorkingTasks < ActiveRecord::Migration[5.1]
  def change
    drop_table :working_tasks
  end
end
