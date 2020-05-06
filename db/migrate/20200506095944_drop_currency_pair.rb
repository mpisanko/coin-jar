class DropCurrencyPair < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :prices, :currency_pairs
    remove_index :prices, :currency_pair_id
    remove_column :prices, :currency_pair_id
    drop_table :currency_pairs
  end
end
