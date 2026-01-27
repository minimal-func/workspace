require 'rails_helper'

RSpec.describe CryptoPriceService do
  before do
    Rails.cache.clear
  end

  describe '.fetch_price' do
    it 'calls DefiLlama' do
      expect(CryptoPriceService).to receive(:fetch_price_from_defillama).and_return(100.0.to_d)
      
      price = CryptoPriceService.fetch_price('ETH')
      expect(price).to eq(100.0)
    end
  end

  describe '.fetch_historical_price' do
    it 'calls DefiLlama with timestamp' do
      timestamp = Time.now
      expect(CryptoPriceService).to receive(:fetch_price_from_defillama).with('ETH', timestamp.to_i, nil).and_return(1500.0.to_d)
      
      price = CryptoPriceService.fetch_historical_price('ETH', timestamp)
      expect(price).to eq(1500.0)
    end
  end

  describe '.symbol_to_address' do
    it 'returns the correct address for common symbols' do
      expect(CryptoPriceService.symbol_to_address('ETH')).to eq('0x0000000000000000000000000000000000000000')
      expect(CryptoPriceService.symbol_to_address('STETH')).to eq('0xae7ab96595de61191157116b237611c2b5130d84')
    end
  end

  describe '.fetch_price_from_defillama' do
    it 'fetches price from DefiLlama API' do
      timestamp = Time.now.to_i
      llama_id = 'ethereum:0x0000000000000000000000000000000000000000'
      url = "https://coins.llama.fi/prices/historical/#{timestamp}/#{llama_id}"
      
      response = double('response', body: { 'coins' => { llama_id => { 'price' => 2500.0 } } }.to_json)
      expect(RestClient).to receive(:get).with(url).and_return(response)
      
      price = CryptoPriceService.fetch_price_from_defillama('ETH', timestamp, nil)
      expect(price).to eq(2500.0)
    end

    it 'handles API errors gracefully' do
      allow(RestClient).to receive(:get).and_raise(StandardError.new("API error"))
      
      price = CryptoPriceService.fetch_price_from_defillama('ETH', Time.now.to_i, nil)
      expect(price).to eq(0)
    end

    it 'retries on 429 Too Many Requests' do
      timestamp = Time.now.to_i
      llama_id = 'ethereum:0x0000000000000000000000000000000000000000'
      url = "https://coins.llama.fi/prices/historical/#{timestamp}/#{llama_id}"
      
      expect(RestClient).to receive(:get).with(url).and_raise(RestClient::TooManyRequests).once
      expect(RestClient).to receive(:get).with(url).and_return(double('response', body: { 'coins' => { llama_id => { 'price' => 2500.0 } } }.to_json)).once
      
      # Mock sleep to speed up tests
      expect(CryptoPriceService).to receive(:sleep).with(2)
      
      price = CryptoPriceService.fetch_price_from_defillama('ETH', timestamp, nil)
      expect(price).to eq(2500.0)
    end
  end
end
