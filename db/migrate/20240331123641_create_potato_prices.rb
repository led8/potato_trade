class CreatePotatoPrices < ActiveRecord::Migration[6.1]
  def change
    create_table :potato_prices do |t|
      t.datetime :time, null: false
      t.decimal :value, precision: 5, scale: 2, null: false

      t.timestamps
    end
  end
end
