class CreateEnergyLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :energy_levels do |t|
      t.integer :value
      t.references :user, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
