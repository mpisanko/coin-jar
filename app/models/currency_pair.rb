class CurrencyPair < ApplicationRecord
  has_many :prices

  validates_presence_of :currency_1, :currency_2
end
