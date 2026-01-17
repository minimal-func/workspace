class CreateGamificationTables < ActiveRecord::Migration[6.0]
  def change
    create_table :points do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :value, null: false, default: 0
      t.string :action, null: false
      t.references :pointable, polymorphic: true
      t.timestamps
    end

    create_table :achievements do |t|
      t.string :name, null: false
      t.string :description
      t.string :badge_image
      t.integer :points_required, default: 0
      t.string :achievement_type
      t.integer :threshold, default: 1
      t.timestamps
    end

    create_table :user_achievements do |t|
      t.references :user, null: false, foreign_key: true
      t.references :achievement, null: false, foreign_key: true
      t.datetime :earned_at
      t.timestamps
    end

    create_table :levels do |t|
      t.integer :level_number, null: false
      t.integer :points_required, null: false
      t.string :name
      t.timestamps
    end

    add_column :users, :total_points, :integer, default: 0
    add_column :users, :level_id, :bigint
    add_foreign_key :users, :levels
  end
end