class Price < ApplicationRecord
  validates_presence_of :last, :bid, :ask, :price_at, :currency

  def self.for(currency)
    where(currency: currency.upcase).order('price_at DESC')
  end

  def self.latest(currencies)
    currencies.map { |c| self.for(c).limit(1).first }
  end

  def readonly?
    !new_record?
  end
end
