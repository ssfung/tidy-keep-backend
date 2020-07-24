class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

# looking into creating invoice different to making one off charges
# will return to this after booking flow is finalized. 
require 'stripe'
def make_stripe_invoice
@booking = Booking.find(params[:id])
Stripe::Invoice.create({
  customer: current_user.first_name,
  customer_email: current_user.email,
  auto_advance: true,
  collection_method: charge_automatically,
  amount: @booking.price * 100,
  currency: 'aud',

})
end

                  # def get_stripe_id
                  #   @booking = Booking.find(params[:id])
                  #   session_id = Stripe::Checkout::Session.create(
                  #     payment_method_types: ['card'],
                  #     customer_email: current_user.email,
                  #     line_items: [{
                  #       name: @listing.title,
                  #       description: @listing.keywords,
                  #       amount: @listing.price * 100,
                  #       currency: 'aud',
                  #       quantity: 1,
                  #     }],
                  #     payment_intent_data: {
                  #       metadata: {
                  #         user_id: current_user.id,
                  #         listing_id: @listing.id
                  #       }
                  #     },
                  #     success_url: "#{root_url}/orders/my_orders?userId=#{current_user.id}&listingId=#{@listing.id}",
                  #     cancel_url: "#{root_url}listings"
                  #   ).id
                  #   render :json => { id: session_id, stripe_public_key: Rails.application.credentials.dig(:stripe, :public_key) }
    end

  def success
    redirect_to my_bookings_path
  end

# not sure if we need or how to set up webhook 
  def webhook
    payment_id = params[:data][:object][:payment_intent]
    payment = Stripe::PaymentIntent.retrieve(payment_id)
    booking_id = payment.metadata.booking_id
    user_id = payment.metadata.user_id
    head 200
  end

  def failure
  end
end