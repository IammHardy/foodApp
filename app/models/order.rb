# app/models/order.rb

class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :user
  belongs_to :cart, optional: true
  has_many :order_items


  # order.rb
def calculate_total_price
  self.total_price = order_items.sum { |item| item.quantity * item.price }
end

  def calculate_total!
  total = order_items.includes(:food).sum do |item|
    item.food.present? ? item.food.price * item.quantity : 0
  end
  update!(total_price: total)
end

  private

  def calculate_total_price
    self.total_price = order_items.includes(:food).sum do |item|
      item.food.present? ? item.food.price * item.quantity : 0
    end
  end


private

def recalculate_total_price_after_save
  if order_items.any?
    update_column(:total_price, order_items.sum { |item| item.food.present? ? item.food.price * item.quantity : 0 })
  end
end

  enum :status, { pending: 0, processing: 1, completed: 2 }

  def self.ransackable_attributes(auth_object = nil)
    [
      "id", "status", "total_price", "created_at", "updated_at",
      "user_id", "address", "phone", "payment_reference",
      "pay_on_delivery", "seen_by_admin", "name"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "order_items"]
  end

  def self.to_csv(orders)
    attributes = %w{id user_email status total created_at}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      orders.each do |order|
        csv << [
          order.id,
          order.user.email,
          order.status,
          order.total_price,
          order.created_at
        ]
      end
    end
  end
end
