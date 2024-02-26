class CreateMaterials < ActiveRecord::Migration[7.1]
  def change
    create_table :materials do |t|
      t.string :title, null: false
      t.string :short_description

      t.references :project, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end
