class CreateLifeCountdowns < ActiveRecord::Migration[5.1]
  def change
    create_table :life_countdowns do |t|
      t.integer :planned_years, required: true
      t.date :born_in, required: true

      t.references :user, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
