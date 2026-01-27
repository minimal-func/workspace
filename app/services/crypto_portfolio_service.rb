require 'ostruct'

class CryptoPortfolioService
  def initialize(user)
    @user = user
    @wallet_address = user.eth_wallet_address&.downcase
  end

  def holdings
    return [] unless @wallet_address

    transactions = @user.crypto_transactions.order(:block_timestamp)
    holdings_map = {}

    transactions.each do |tx|
      symbol = tx.token_symbol.strip.upcase
      holdings_map[symbol] ||= {
        symbol: symbol,
        amount: 0,
        total_cost: 0,
        buy_price: 0,
        token_address: tx.token_address
      }

      is_incoming = tx.to_address.downcase == @wallet_address
      amount = tx.value

      if is_incoming
        historical_price = CryptoPriceService.fetch_historical_price(symbol, tx.block_timestamp, tx.token_address)
        holdings_map[symbol][:amount] += amount
        holdings_map[symbol][:total_cost] += amount * historical_price
      else
        # For outgoing, we reduce amount.
        # Cost basis adjustment: simplified version is to reduce total_cost proportionally
        if holdings_map[symbol][:amount] > 0
          proportion = amount / holdings_map[symbol][:amount]
          holdings_map[symbol][:total_cost] -= holdings_map[symbol][:total_cost] * [proportion, 1.0].min
        end
        holdings_map[symbol][:amount] -= amount
      end
    end

    holdings_map.values.map do |h|
      current_price = CryptoPriceService.fetch_price(h[:symbol], h[:token_address])
      buy_price = h[:amount] > 0 ? h[:total_cost] / h[:amount] : 0

      OpenStruct.new({
        symbol: h[:symbol],
        amount: h[:amount],
        buy_price: buy_price,
        current_price: current_price,
        current_value: h[:amount] * current_price,
        total_cost: h[:total_cost]
      }).tap do |os|
        def os.profit_loss
          current_value - total_cost
        end

        def os.profit_loss_percentage
          return 0 if total_cost.zero? && profit_loss.zero?
          return 100 if total_cost.zero? && profit_loss.positive?
          return -100 if total_cost.zero? && profit_loss.negative?

          (profit_loss / total_cost) * 100
        end
      end
    end
  end
end
