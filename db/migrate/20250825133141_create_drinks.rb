class CreateDrinks < ActiveRecord::Migration[8.0]
  def change
    create_table :drinks do |t|
      t.string :name
      t.text :description
      t.decimal :price

      t.timestamps
    end
  end
end
