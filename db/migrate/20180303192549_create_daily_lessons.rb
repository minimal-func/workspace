class CreateDailyLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_lessons do |t|
      t.text :content
      t.references :user, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
