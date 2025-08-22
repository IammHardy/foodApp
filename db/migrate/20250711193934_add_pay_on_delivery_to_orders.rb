class AddPayOnDeliveryToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :pay_on_delivery, :boolean
  end
end
