class AddPriceToFoods < ActiveRecord::Migration[8.0]
  def change
    add_column :foods, :price, :decimal,  precision: 8, scale: 2
  end
end
