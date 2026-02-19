class CryptoPriceService
  class << self
    def fetch_price(symbol, token_address = nil)
      cache_key = "crypto_price_#{symbol.upcase}_#{token_address}"
      Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
        fetch_price_from_defillama(symbol, Time.now.to_i, token_address)
      end
    end

    def fetch_historical_price(symbol, timestamp, token_address = nil)
      unix_timestamp = timestamp.to_i
      date_str = timestamp.strftime('%d-%m-%Y')
      cache_key = "historical_crypto_price_#{symbol.upcase}_#{token_address}_#{date_str}"

      Rails.cache.fetch(cache_key, expires_in: 1.year) do
        fetch_price_from_defillama(symbol, unix_timestamp, token_address)
      end
    rescue StandardError => e
      Rails.logger.error "Error in fetch_historical_price for #{symbol}: #{e.message}"
      0
    end

    def symbol_to_address(symbol)
      @symbol_to_address_cache ||= {
        "ETH" => "0x0000000000000000000000000000000000000000",
        "WETH" => "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
        "USDT" => "0xdac17f958d2ee523a2206206994597c13d831ec7",
        "USDC" => "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
        "DAI" => "0x6b175474e89094c44da98b954eedeac495271d0f",
        "WBTC" => "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
        "LINK" => "0x514910771af9ca656af840dff83e8264ecf986ca",
        "UNI" => "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984",
        "STETH" => "0xae7ab96595de61191157116b237611c2b5130d84",
        "MATIC" => "0x7d1afa7b718fb893db30a3abc0cfc608aacfebb0",
        "SHIB" => "0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce"
      }
      @symbol_to_address_cache[symbol.upcase]
    end

    def fetch_price_from_defillama(symbol, timestamp, token_address)
      address = if symbol.upcase == 'ETH'
                  '0x0000000000000000000000000000000000000000'
                elsif token_address.present?
                  token_address
                else
                  symbol_to_address(symbol)
                end

      return 0 unless address

      llama_id = "ethereum:#{address}"

      with_retries do
        url = "https://coins.llama.fi/prices/historical/#{timestamp}/#{llama_id}"
        response = RestClient.get(url)
        data = JSON.parse(response.body)
        # DefiLlama returns { "coins": { "ethereum:0x...": { "price": 123.45, ... } } }
        data.dig('coins', llama_id, 'price')&.to_d || 0
      end
    rescue StandardError => e
      Rails.logger.warn "DefiLlama error for #{symbol} (#{address}): #{e.message}"
      0
    end

    private

    def with_retries(max_retries = 3)
      retries = 0
      begin
        yield
      rescue RestClient::TooManyRequests => e
        if retries < max_retries
          retries += 1
          sleep_time = 2**retries
          Rails.logger.warn "DefiLlama 429 received. Retrying in #{sleep_time}s (attempt #{retries}/#{max_retries})..."
          sleep(sleep_time)
          retry
        else
          raise e
        end
      end
    end
  end
end
