class AddPurchasedFeaturesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :purchased_features, :string, array: true, default: [], null: false
  end
end
