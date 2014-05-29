Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY'] 

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    reference_id = event.data.object.id
    amount = event.data.object.amount
    user = User.where(customer_token: event.data.object.customer).first
    Payment.create(user: user, amount: amount, reference_id: reference_id)
  end
end