class ChangeStatusToIntegerInOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :status, :string
    add_column :orders, :status, :integer, default: 0
  end
end
