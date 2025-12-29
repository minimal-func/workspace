class AddEthWalletAddressToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :eth_wallet_address, :string
  end
end
