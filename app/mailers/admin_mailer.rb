class AdminMailer < ApplicationMailer
  default to: ENV['ADMIN_EMAIL']

  def order_paid_notification(order)
    @order = order
    mail(subject: "New Paid Order from #{@order.name}")
  end
end
