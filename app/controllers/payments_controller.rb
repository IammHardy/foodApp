require 'httparty'

class PaymentsController < ApplicationController
  # def pay
  #   puts "PAYMENT STARTED"
  #   order = current_user.orders.find(params[:order_id])
  #   amount_kobo = (order.order_items.sum { |i| i.price * i.quantity } * 100).round

  #   reference = "ORD#{order.id}-#{Time.now.to_i}"
    

  #   response = HTTParty.post(
  #     "https://api.paystack.co/transaction/initialize",
  #     headers: {
  #       "Authorization" => "Bearer #{ENV['PAYSTACK_SECRET_KEY']}",
  #       "Content-Type" => "application/json"
  #     },
  #     body: {
  #       email: current_user.email,
  #       amount: amount_kobo,
  #       reference: reference,
  #       callback_url: verify_payment_url
  #     }.to_json
  #   )
  #     puts "Paystack response: #{response.body}"
  #   if response.parsed_response["status"]
  #     order.update!(payment_reference: reference)
  #     redirect_to response.parsed_response["data"]["authorization_url"], allow_other_host: true
  #   else
  #     redirect_to order_path(order), alert: "Payment failed to initialize"
  #   end
  # end
  def pay
  puts "PAYMENT STARTED"
  order = current_user.orders.find(params[:order_id])
  
  amount_decimal = order.order_items.sum { |item| item.quantity * item.food.price }
  amount_kobo = (amount_decimal * 100).to_i

  puts "Order amount (decimal): #{amount_decimal}"
  puts "Order amount (kobo): #{amount_kobo}"

  reference = "ORD#{order.id}-#{Time.now.to_i}"

  response = HTTParty.post(
    "https://api.paystack.co/transaction/initialize",
    headers: {
      "Authorization" => "Bearer #{ENV['PAYSTACK_SECRET_KEY']}",
      "Content-Type" => "application/json"
    },
    body: {
      email: current_user.email,
      amount: amount_kobo,
      reference: reference,
      callback_url: verify_payment_url
    }.to_json
  )

  if response.parsed_response["status"]
    order.update!(payment_reference: reference)
    redirect_to response.parsed_response["data"]["authorization_url"], allow_other_host: true
  else
    redirect_to order_path(order), alert: "Payment failed to initialize"
  end
end


  def verify
    reference = params[:reference]

    response = HTTParty.get(
      "https://api.paystack.co/transaction/verify/#{reference}",
      headers: {
        "Authorization" => "Bearer #{ENV['PAYSTACK_SECRET_KEY']}"
      }
    )

    if response.parsed_response["status"]
      order = Order.find_by(payment_reference: reference)
      order.update!(status: "processing") if order.present?
      # Notify admin via WhatsApp
    send_whatsapp_notification(order)

    # Notify admin via email
    AdminMailer.order_paid_notification(order).deliver_later
    redirect_to order_path(order), notice: "Payment verified successfully."
    else
      redirect_to root_path, alert: "Payment verification failed."
    end
  end
  private

def send_whatsapp_notification(order)
   items = order.order_items.map do |item|
    "#{item.food.name} x#{item.quantity} (₦#{item.price})"
  end.join(", ")
  message = "New Paid Order!\n" \
            "Name: #{order.name}\n" \
            "Phone: #{order.phone}\n" \
            "Address: #{order.address}\n" \
            "Items: #{items}\n" \
            "Total: ₦#{order.total_price}\n" \
            "Status: #{order.status}"

  number = ENV['ADMIN_WHATSAPP_NUMBER']
  apikey = ENV['CALLMEBOT_API_KEY']

  HTTParty.get("https://api.callmebot.com/whatsapp.php", query: {
    phone: number,
    text: message,
    apikey: apikey
  })
end

end
