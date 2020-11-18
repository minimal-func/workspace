class AddClosedToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :closed, :boolean, default: false
  end
end
