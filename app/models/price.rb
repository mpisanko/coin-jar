class Price < ApplicationRecord
  validates_presence_of :last, :bid, :ask, :price_at, :currency

  def readonly?
    !new_record?
  end
end
