require 'rails_helper'

RSpec.describe 'CurrencyPrice' do
  subject { CurrencyPrice.new }
  let(:currencies) { %w[ETHAUD BTCAUD] }
  let(:response) { RestClient::Response.new }
  describe 'btc' do
    let(:btc) { CurrencyPair.new(currency_1: 'BTC', currency_2: 'AUD').tap(&:save) }
    let(:btc_price) do
      {
        'last'         => '14090.00000000',
        'current_time' => '2020-05-06T00:12:33.345770Z',
        'bid'          => '14040.00000000',
        'ask'          => '14080.00000000'
      }.to_json
    end
    context 'request successful' do
      before do
        allow(RestClient).to receive(:get).and_return(response)
        allow(response).to receive(:body).and_return(btc_price)
      end
      it 'saves the price it read' do
        subject.btc
        expect(Price.last.bid).to eq(14040.0)
      end
    end
  end

  describe 'eth' do
    let(:eth) { CurrencyPair.new(currency_1: 'ETH', currency_2: 'AUD').tap(&:save) }
    let(:eth_price) do
      {
        'last'          => '318.20000000',
        'current_time'  => '2020-05-06T00:14:38.144159Z',
        'bid'           => '317.80000000',
        'ask'           => '320.30000000'
      }.to_json
    end
    context 'request successful' do
      before do
        allow(RestClient).to receive(:get).and_return(response)
        allow(response).to receive(:body).and_return(eth_price.to_json)
      end
      it 'saves the price it read' do
        subject.eth
        expect(Price.last.bid).to eq(317.8)
      end
    end
  end
end