require 'rails_helper'

RSpec.describe CurrencyPrice do
  subject { described_class.new }
  let(:response) { RestClient::Response.new }
  describe 'btc' do
    let!(:btc) { CurrencyPair.new(currency_1: 'BTC', currency_2: 'AUD').tap(&:save) }
    let(:btc_price) do
      {
        'last'         => '14090.00000000',
        'current_time' => '2020-05-06T00:12:33.345770Z',
        'bid'          => '14040.00000000',
        'ask'          => '14080.00000000',
      }.to_json
    end
    context 'request successful' do
      before do
        allow(RestClient).to receive(:get).and_return(response)
        allow(response).to receive(:body).and_return(btc_price)
      end
      it 'saves the price it read' do
        expect(RestClient).to receive(:get).with(CurrencyPrice::TICKER % 'BTCAUD')
        subject.btc
        saved = Price.last
        expect(saved.bid).to eq(14040.0)
        expect(saved.currency_pair.to_s).to eq('BTCAUD')
      end
    end

    context 'failed request' do
      before do
        allow(RestClient).to receive(:get).with(CurrencyPrice::TICKER % 'BTCAUD').and_raise(RestClient::NotFound)
      end
      it 'returns currency symbol mapped to nil' do
        expect(subject.btc).to eq({ btc: nil })
      end
    end

    context 'problem saving price' do
      let(:price) {double(Price)}
      before do
        allow(RestClient).to receive(:get).with(CurrencyPrice::TICKER % 'BTCAUD').and_return(response)
        allow(response).to receive(:body).and_return(btc_price)
        allow(Price).to receive(:new).and_return(price)
        allow(price).to receive(:save).and_raise(ActiveRecord::RecordInvalid)
      end
      it 'returns currency symbol mapped to nil' do
        expect(subject.btc).to eq({ btc: nil })
      end
    end
  end

  describe 'eth' do
    let!(:eth) { CurrencyPair.new(currency_1: 'ETH', currency_2: 'AUD').tap(&:save) }
    let(:eth_price) do
      {
        'last'          => '318.20000000',
        'current_time'  => '2020-05-06T00:14:38.144159Z',
        'bid'           => '317.80000000',
        'ask'           => '320.30000000',
      }.to_json
    end
    context 'request successful' do
      before do
        allow(RestClient).to receive(:get).with(CurrencyPrice::TICKER % 'ETHAUD').and_return(response)
        allow(response).to receive(:body).and_return(eth_price)
      end
      it 'saves the price it read' do
        subject.eth
        saved = Price.last
        expect(saved.bid).to eq(317.8)
        expect(saved.currency_pair.currency_1).to eq('ETH')
      end
    end
  end

  describe 'call' do
    let!(:btc) { CurrencyPair.new(currency_1: 'BTC', currency_2: 'AUD').tap(&:save) }
    let!(:eth) { CurrencyPair.new(currency_1: 'ETH', currency_2: 'AUD').tap(&:save) }
    let(:btc_price) do
      {
        'last'         => '14090.00000000',
        'current_time' => '2020-05-06T00:12:33.345770Z',
        'bid'          => '14040.00000000',
        'ask'          => '14080.00000000',
      }.to_json
    end
    let(:eth_price) do
      {
        'last'          => '318.20000000',
        'current_time'  => '2020-05-06T00:14:38.144159Z',
        'bid'           => '317.80000000',
        'ask'           => '320.30000000',
      }.to_json
    end
    context 'requests successful' do
      let(:response_1) { RestClient::Response.new }
      before do
        allow(RestClient).to receive(:get).with(CurrencyPrice::TICKER % 'BTCAUD').and_return(response)
        allow(response).to receive(:body).and_return(btc_price)
        allow(RestClient).to receive(:get).with(CurrencyPrice::TICKER % 'ETHAUD').and_return(response_1)
        allow(response_1).to receive(:body).and_return(eth_price)
      end
      it 'retrieves both prices' do
        retrieved = subject.call
        puts "call yielded #{retrieved}"
        expect(retrieved[:btc].bid).to eq(14040.0)
        expect(retrieved[:btc].currency_pair.to_s).to eq('BTCAUD')
        expect(retrieved[:eth].bid).to eq(317.8)
        expect(retrieved[:eth].currency_pair.currency_1).to eq('ETH')
      end
    end
  end
end