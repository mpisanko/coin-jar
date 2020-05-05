class IncreasePricePrecision < ActiveRecord::Migration[6.0]
  def change
    change_column :prices, :last, :decimal, precision: 16, scale: 8
    change_column :prices, :bid, :decimal, precision: 16, scale: 8
    change_column :prices, :ask, :decimal, precision: 16, scale: 8
  end
end
