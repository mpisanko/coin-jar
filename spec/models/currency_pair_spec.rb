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
end
