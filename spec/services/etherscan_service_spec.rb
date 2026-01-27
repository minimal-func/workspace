require 'rails_helper'

RSpec.describe EtherscanService do
  describe '.fetch_erc20_transactions' do
    let(:address) { '0x1234567890123456789012345678901234567890' }
    let(:api_key) { 'test_api_key' }

    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('ETHERSCAN_API_KEY').and_return(api_key)
    end

    it 'returns empty array if address is blank' do
      expect(EtherscanService.fetch_erc20_transactions('')).to eq([])
    end

    context 'with successful API response' do
      let(:response_body) do
        {
          status: '1',
          message: 'OK',
          result: [
            {
              timeStamp: '1614556800',
              tokenSymbol: 'USDT',
              from: '0xabc',
              to: '0xdef',
              value: '1000000',
              tokenDecimal: '6'
            }
          ]
        }.to_json
      end

      before do
        stub_request(:get, /api.etherscan.io\/v2\/api/)
          .with(query: hash_including(chainid: '1', module: 'account', action: 'tokentx', address: address))
          .to_return(status: 200, body: response_body)
      end

      it 'returns transactions' do
        transactions = EtherscanService.fetch_erc20_transactions(address)
        expect(transactions.size).to eq(1)
        expect(transactions.first['tokenSymbol']).to eq('USDT')
      end
    end

    context 'with error API response' do
      let(:response_body) do
        {
          status: '0',
          message: 'NOTOK',
          result: 'Error message'
        }.to_json
      end

      before do
        stub_request(:get, /api.etherscan.io\/v2\/api/)
          .to_return(status: 200, body: response_body)
      end

      it 'returns empty array and logs error' do
        expect(Rails.logger).to receive(:error).with(/Etherscan API error/)
        expect(EtherscanService.fetch_erc20_transactions(address)).to eq([])
      end
    end

    context 'with request exception' do
      before do
        allow(RestClient).to receive(:get).and_raise(StandardError.new('API down'))
      end

      it 'returns empty array and logs error' do
        expect(Rails.logger).to receive(:error).with(/Error fetching ERC-20 transactions: API down/)
        expect(EtherscanService.fetch_erc20_transactions(address)).to eq([])
      end
    end
  end
end
