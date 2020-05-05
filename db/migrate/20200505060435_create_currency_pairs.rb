class CreateCurrencyPairs < ActiveRecord::Migration[6.0]
  def change
    create_table :currency_pairs do |t|
      t.string :currency_1
      t.string :currency_2

      t.timestamps
    end
  end
end
