class AddUniqueIndexToCryptoHoldings < ActiveRecord::Migration[7.1]
  def change
    add_index :crypto_holdings, [:user_id, :symbol], unique: true
  end
end
