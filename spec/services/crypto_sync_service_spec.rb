require 'rails_helper'

RSpec.describe CryptoSyncService do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', eth_wallet_address: '0x123') }

  describe '.sync_for_user' do
    let(:erc20_transactions) do
      [
        {
          'hash' => '0x1',
          'blockNumber' => '100',
          'timeStamp' => Time.now.to_i.to_s,
          'tokenSymbol' => 'USDT',
          'tokenDecimal' => '6',
          'value' => '10000000', # 10 USDT
          'from' => '0xabc',
          'to' => '0x123',
          'contractAddress' => '0xusdt',
          'gasUsed' => '21000',
          'gasPrice' => '1000000000'
        },
        {
          'hash' => '0x2',
          'blockNumber' => '101',
          'timeStamp' => Time.now.to_i.to_s,
          'tokenSymbol' => 'USDT',
          'tokenDecimal' => '6',
          'value' => '2000000', # 2 USDT
          'from' => '0x123',
          'to' => '0xdef',
          'contractAddress' => '0xusdt',
          'gasUsed' => '21000',
          'gasPrice' => '1000000000'
        }
      ]
    end

    let(:eth_transactions) do
      [
        {
          'hash' => '0x3',
          'blockNumber' => '102',
          'timeStamp' => Time.now.to_i.to_s,
          'value' => '1000000000000000000', # 1 ETH
          'from' => '0xabc',
          'to' => '0x123',
          'gasUsed' => '21000',
          'gasPrice' => '1000000000'
        },
        {
          'hash' => '0x4',
          'blockNumber' => '103',
          'timeStamp' => Time.now.to_i.to_s,
          'value' => '10000000000000000000000000000', # 10,000,000,000 ETH
          'from' => '0xabc',
          'to' => '0x123',
          'gasUsed' => '21000',
          'gasPrice' => '1000000000'
        }
      ]
    end

    before do
      allow(EtherscanService).to receive(:fetch_erc20_transactions).with('0x123').and_return(erc20_transactions)
      allow(EtherscanService).to receive(:fetch_eth_transactions).with('0x123').and_return(eth_transactions)
      allow(CryptoPriceService).to receive(:fetch_price).and_return(2000.to_d)
      allow(CryptoPriceService).to receive(:fetch_historical_price).and_return(1500.to_d)
    end

    it 'creates or updates crypto transactions based on data and calculates cost basis' do
      expect {
        CryptoSyncService.sync_for_user(user)
      }.to change(CryptoTransaction, :count).by(4)

      portfolio = CryptoPortfolioService.new(user)
      usdt_holding = portfolio.holdings.find { |h| h.symbol == 'USDT' }
      expect(usdt_holding.amount).to eq(8) # 10 - 2
      # Cost basis: 10 USDT * 1500 (historical) = 15000.
      # Sell 2 USDT: 2/10 = 0.2. 15000 - (15000 * 0.2) = 12000
      expect(usdt_holding.total_cost).to eq(12000)
      expect(usdt_holding.buy_price).to eq(1500)

      eth_holding = portfolio.holdings.find { |h| h.symbol == 'ETH' }
      expect(eth_holding.amount).to eq(10_000_000_001)
      # 1 + 10,000,000,000 = 10,000,000,001
      # Cost: 10,000,000,001 * 1500 = 15,000,000,001,500
      expect(eth_holding.total_cost).to eq(15_000_000_001_500)

      expect(user.crypto_transactions.count).to eq(4)
    end

    it 'does not duplicate transactions' do
      CryptoSyncService.sync_for_user(user)

      expect {
        CryptoSyncService.sync_for_user(user)
      }.not_to change(CryptoTransaction, :count)

      portfolio = CryptoPortfolioService.new(user)
      usdt_holding = portfolio.holdings.find { |h| h.symbol == 'USDT' }
      expect(usdt_holding.amount).to eq(8)
    end
  end
end
