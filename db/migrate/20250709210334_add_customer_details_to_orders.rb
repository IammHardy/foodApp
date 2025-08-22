class AddCustomerDetailsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :name, :string
    add_column :orders, :address, :string
    add_column :orders, :phone, :string
  end
end
