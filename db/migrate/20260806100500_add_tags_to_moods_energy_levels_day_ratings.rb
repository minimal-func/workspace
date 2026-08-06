class AddTagsToMoodsEnergyLevelsDayRatings < ActiveRecord::Migration[7.1]
  def change
    add_column :moods, :tags, :string, array: true, default: [], null: false
    add_column :day_ratings, :tags, :string, array: true, default: [], null: false
    add_column :energy_levels, :tags, :string, array: true, default: [], null: false
  end
end
