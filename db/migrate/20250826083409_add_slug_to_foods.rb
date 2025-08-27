class AddSlugToFoods < ActiveRecord::Migration[8.0]
  def change
    add_column :foods, :slug, :string
    add_index :foods, :slug, unique: true
  end
end
