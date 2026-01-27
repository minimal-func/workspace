class CreateCryptoTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :crypto_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :transaction_hash
      t.integer :block_number
      t.datetime :block_timestamp
      t.string :from_address
      t.string :to_address
      t.decimal :value, precision: 18, scale: 8
      t.string :token_symbol
      t.string :token_name
      t.string :token_address
      t.string :transaction_type
      t.decimal :gas_used, precision: 18, scale: 8
      t.decimal :gas_price, precision: 18, scale: 8

      t.timestamps
    end
    add_index :crypto_transactions, :transaction_hash
    add_index :crypto_transactions, :from_address
    add_index :crypto_transactions, :to_address
    add_index :crypto_transactions, :token_address
  end
end
