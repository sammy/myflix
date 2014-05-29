Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY'] 

StripeEvent.configure do |events|
  
  events.subscribe 'charge.succeeded' do |event|
    reference_id = event.data.object.id
    amount = event.data.object.amount
    user = User.where(customer_token: event.data.object.customer).first
    Payment.create(user: user, amount: amount, reference_id: reference_id)
  end


  events.subscribe 'charge.failed' do |event|
    user = User.find_by(customer_token: event.data.object.customer)
    user.update_attribute(:is_locked, true)
    card = event.data.object.card
    AppMailer.notify_of_failed_payment(user,card).deliver
  end

end