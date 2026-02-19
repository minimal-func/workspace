class CryptoSyncService
  class << self
    def sync_for_user(user)
      return unless user.eth_wallet_address.present?

      wallet_address = user.eth_wallet_address.downcase

      eth_txs = EtherscanService.fetch_eth_transactions(wallet_address)
      erc20_txs = EtherscanService.fetch_erc20_transactions(wallet_address)

      process_transactions(user, eth_txs, 'ETH')
      process_transactions(user, erc20_txs, 'ERC20')
    end

    private

    def process_transactions(user, transactions, type)
      transactions.each do |tx|
        next if user.crypto_transactions.exists?(transaction_hash: tx['hash'])

        user.crypto_transactions.create!(
          transaction_hash: tx['hash'],
          block_number: tx['blockNumber'],
          block_timestamp: Time.at(tx['timeStamp'].to_i),
          from_address: tx['from'],
          to_address: tx['to'],
          value: format_value(tx, type),
          token_symbol: tx['tokenSymbol'] || 'ETH',
          token_name: tx['tokenName'] || 'Ethereum',
          token_address: tx['contractAddress'],
          transaction_type: type,
          gas_used: tx['gasUsed'],
          gas_price: tx['gasPrice']
        )
      end
    end

    def format_value(tx, type)
      decimals = type == 'ETH' ? 18 : (tx['tokenDecimal'] || 18).to_i
      tx['value'].to_d / (10**decimals)
    end
  end
end
