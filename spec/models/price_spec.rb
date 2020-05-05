require 'rails_helper'

RSpec.describe Price, type: :model do
  subject do
    described_class.new(
      { last: 1000,
        ask: 1001,
        bid: 999,
        price_at: Time.current,
        currency_pair: CurrencyPair.new({ currency_1: 'ETH', currency_2: 'AUD' }) }
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  %i[last bid ask price_at].each do |attribute|
    let(:price) { subject.clone.tap { |p| p.send("#{attribute}=", nil) } }
    it "is not valid without #{attribute}" do
      expect(price).to_not be_valid
    end
  end
end
