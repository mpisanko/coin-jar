class Price < ApplicationRecord
  belongs_to :currency_pair

  validates_presence_of :last, :bid, :ask, :price_at

  def readonly?
    !new_record?
  end
end
