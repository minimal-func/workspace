class CreateMoods < ActiveRecord::Migration[6.0]
  def change
    create_table :moods do |t|
      t.integer :value
      t.references :user, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
