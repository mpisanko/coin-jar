class CreatePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :prices do |t|
      t.decimal :last, precision: 8, scale: 8
      t.decimal :ask, precision: 8, scale: 8
      t.decimal :bid, precision: 8, scale: 8
      t.timestamp :price_at
      t.references :currency_pair, null: false, foreign_key: true

      t.timestamps
    end
  end
end
