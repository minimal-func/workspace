class CreateDayRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :day_ratings do |t|
      t.integer :value
      t.references :user, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
