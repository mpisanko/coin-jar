require 'rails_helper'

RSpec.describe Price, type: :model do
  subject do
    described_class.new(
      last: 10000.00666,
      ask: 10001.00999,
      bid: 9999.00333,
      price_at: Time.current,
      currency: 'ETHAUD'
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'has expected values' do
    expect(subject.last).to eq(10000.00666)
    expect(subject.bid).to eq(9999.00333)
    expect(subject.ask).to eq(10001.00999)
    expect(subject.currency).to eq('ETHAUD')
  end

  %i[last bid ask price_at currency].each do |attribute|
    let(:price) { subject.clone.tap { |p| p.send("#{attribute}=", nil) } }
    it "is not valid without #{attribute}" do
      expect(price).to_not be_valid
    end
  end

  %i[last bid ask price_at currency].each do |attribute|
    it "has readable #{attribute}" do
      expect(subject.public_send(attribute)).not_to be_nil
    end
  end

  it 'is immutable after creation' do
    subject.save
    subject.last += 666
    expect { subject.save }.to raise_error(ActiveRecord::ReadOnlyRecord)
  end

  context 'has same values after saving' do
    let(:saved) { subject.clone.tap(&:save) }
    %i[last bid ask price_at currency].each do |attribute|
      it 'has the same value as input value' do
        expect(Price.find(saved.id).send(attribute)).to eq(subject.send(attribute))
      end
    end
  end

  context 'for currency' do
    it 'selects only those with specified currency' do
      described_class.delete_all
      now = Time.current
        10.times.each do |i|
          described_class.create(last: i, bid: i, ask: i, currency: 'ETHAUD', price_at: now - i.hours)
          described_class.create(last: i, bid: i, ask: i, currency: 'BTCAUD', price_at: now - i.hours)
        end
      expect(described_class.for('ethaud').map(&:currency).uniq).to eq ['ETHAUD']
      expect(described_class.for('btcaud').map(&:currency).uniq).to eq ['BTCAUD']
      expect(described_class.for('BTCAUD').count).to eq 10
      expect(described_class.for('ETHAUD').count).to eq 10
    end
  end

  context 'latest' do
    it 'selects only most recent with specified currency' do
      now = Time.current
      10.times.each do |i|
        described_class.create(last: i, bid: i, ask: i, currency: 'ETHAUD', price_at: now - i.hours)
        described_class.create(last: i, bid: i, ask: i, currency: 'BTCAUD', price_at: now - i.hours)
      end
      expect(described_class.latest(['ETHAUD']).first.price_at.to_i).to eq now.to_i
      expect(described_class.latest(['ETHAUD']).first.currency).to eq 'ETHAUD'
      expect(described_class.latest(['ETHAUD']).first.price_at.to_i).to eq now.to_i
      expect(described_class.latest(['BTCAUD']).first.currency).to eq 'BTCAUD'
      expect(described_class.latest(['ETHAUD', 'BTCAUD']).map(&:currency)).to eq ['ETHAUD', 'BTCAUD']
      expect(described_class.latest(['ETHAUD', 'BTCAUD']).map(&:price_at).map(&:to_i)).to eq [now.to_i, now.to_i]
    end
  end
end
