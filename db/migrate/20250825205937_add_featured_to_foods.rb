class AddFeaturedToFoods < ActiveRecord::Migration[8.0]
  def change
    add_column :foods, :featured, :boolean
  end
end
