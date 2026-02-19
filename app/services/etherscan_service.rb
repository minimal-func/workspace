class EtherscanService
  BASE_URL = 'https://api.etherscan.io/v2/api'.freeze

  class << self
    def fetch_erc20_transactions(address)
      fetch_transactions(address, 'tokentx')
    end

    def fetch_eth_transactions(address)
      fetch_transactions(address, 'txlist')
    end

    private

    def fetch_transactions(address, action)
      return [] if address.blank?

      api_key = ENV['ETHERSCAN_API_KEY']
      params = {
        chainid: 1,
        module: 'account',
        action: action,
        address: address,
        startblock: 0,
        endblock: 99_999_999,
        sort: 'desc',
        apikey: api_key
      }

      begin
        response = RestClient.get(BASE_URL, { params: params })
        data = JSON.parse(response.body)

        if data['status'] == '1'
          data['result']
        else
          Rails.logger.error "Etherscan API error (#{action}): #{data['message']}"
          []
        end
      rescue StandardError => e
        Rails.logger.error "Error fetching transactions (#{action}): #{e.message}"
        []
      end
    end
  end
end
