class IncreasePrecisionForCryptoModels < ActiveRecord::Migration[7.1]
  def change
    change_column :crypto_holdings, :amount, :decimal, precision: 36, scale: 18
    change_column :crypto_holdings, :buy_price, :decimal, precision: 36, scale: 18

    change_column :crypto_transactions, :value, :decimal, precision: 36, scale: 18
    change_column :crypto_transactions, :gas_used, :decimal, precision: 36, scale: 18
    change_column :crypto_transactions, :gas_price, :decimal, precision: 36, scale: 18
  end
end
