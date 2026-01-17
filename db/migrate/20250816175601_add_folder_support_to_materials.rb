class AddFolderSupportToMaterials < ActiveRecord::Migration[7.1]
  def change
    add_reference :materials, :parent, null: true, foreign_key: { to_table: :materials }
    add_column :materials, :is_folder, :boolean, default: false, null: false
    add_index :materials, [:parent_id, :is_folder]
  end
end