class CurrencyPair < ApplicationRecord
  has_many :prices, -> { order('price_at desc') }

  validates_presence_of :currency_1, :currency_2

  def readonly?
    !new_record?
  end

  def to_s
    "#{currency_1}#{currency_2}"
  end

  def latest
    prices.limit(1).first
  end
end
