class DropCryptoHoldings < ActiveRecord::Migration[7.1]
  def change
    drop_table :crypto_holdings do |t|
      t.bigint "user_id", null: false
      t.string "symbol", null: false
      t.decimal "amount", precision: 36, scale: 18, default: "0.0", null: false
      t.decimal "buy_price", precision: 36, scale: 18, default: "0.0", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["user_id", "symbol"], name: "index_crypto_holdings_on_user_id_and_symbol", unique: true
      t.index ["user_id"], name: "index_crypto_holdings_on_user_id"
    end
  end
end
