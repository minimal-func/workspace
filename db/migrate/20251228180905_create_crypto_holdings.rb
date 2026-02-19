class CreateCryptoHoldings < ActiveRecord::Migration[7.1]
  def change
    create_table :crypto_holdings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :symbol, null: false
      t.decimal :amount, precision: 18, scale: 8, default: 0, null: false
      t.decimal :buy_price, precision: 18, scale: 8, default: 0, null: false

      t.timestamps
    end
  end
end
