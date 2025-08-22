class AddSeenByAdminToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :seen_by_admin, :boolean
  end
end
