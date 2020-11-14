class CreateDailyGratitudes < ActiveRecord::Migration[6.0]
  def change
    create_table :daily_gratitudes do |t|
      t.text :content
      t.references :user, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
