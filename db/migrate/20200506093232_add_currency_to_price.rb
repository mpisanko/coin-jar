class AddCurrencyToPrice < ActiveRecord::Migration[6.0]
  def change
    add_column :prices, :currency, :string
    add_index :prices, :currency
    CurrencyPair.all.each do |currency|
      currency.prices.update_all(currency: currency.to_s)
    end
  end
end
