class AddPriceAtIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :prices, :price_at
  end
end
