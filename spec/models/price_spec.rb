require 'rails_helper'

RSpec.describe Price, type: :model do
  subject do
    described_class.new(
      last: 10000.00666,
      ask: 10001.00999,
      bid: 9999.00333,
      price_at: Time.current,
      currency_pair: CurrencyPair.new(currency_1: 'ETH', currency_2: 'AUD')
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

  %i[last bid ask price_at currency_pair].each do |attribute|
    it "has readable #{attribute}" do
      expect(subject.public_send(attribute)).not_to be_nil
    end
  end

  it 'is immutable after creation' do
    subject.save
    subject.last += 666
    expect { subject.save }.to raise_error(ActiveRecord::ReadOnlyRecord)
  end
end
