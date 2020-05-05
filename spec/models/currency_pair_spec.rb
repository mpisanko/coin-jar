require 'rails_helper'

RSpec.describe CurrencyPair, type: :model do
  subject { described_class.new({ currency_1: 'BTC', currency_2: 'AUD' }) }
  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without currency_1' do
    subject.currency_1 = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without currency_2' do
    subject.currency_2 = nil
    expect(subject).to_not be_valid
  end

  it 'is immutable after creation' do
    subject.save
    subject.currency_1 = 'ETH'
    expect { subject.save }.to raise_error(ActiveRecord::ReadOnlyRecord)
  end

  it 'concatenates currency_1 and currency_2 to show string' do
    expect(subject.to_s).to eq('BTCAUD')
  end

  describe 'Associations' do
    it { should have_many(:prices).without_validating_presence.order('price_at desc') }

    context 'latest' do
      let(:currency_pair) { CurrencyPair.new(currency_1: 'BTC', currency_2: 'AUD') }
      let(:price_1) do
        Price.new(last: 1000, ask: 1001, bid: 999,
                  price_at: (Time.current - 1.minute),
                  currency_pair: currency_pair)
      end
      let(:price_2) do
        Price.new(last: 1010, ask: 1011, bid: 991,
          price_at: (Time.current - 2.minutes),
          currency_pair: currency_pair)
      end
      it 'returns the most recent price for a currency' do
        currency_pair.save
        price_1.save
        price_2.save
        expect(currency_pair.latest).to eq(price_1)
      end
    end
  end
end
