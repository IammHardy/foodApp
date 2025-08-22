class AddPaymentReferenceToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :payment_reference, :string
  end
end
