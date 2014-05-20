require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "charges the card succesfully", :vcr do
        Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
        token = Stripe::Token.create( 
          :card  => {
            :number     =>  '4242424242424242',
            :exp_month  =>  12,
            :exp_year   =>  2016,
            :cvc        =>  666
                    },).id
        response = StripeWrapper::Charge.create(
          :amount       =>  400,
          :card         =>  token,
          :description  => 'A valid charge'
          )
        expect(response).to be_successful
      end

      it "makes a card declined charge", :vcr do
        Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
        token = Stripe::Token.create( 
          :card  => {
            :number     =>  '4000000000000002',
            :exp_month  =>  12,
            :exp_year   =>  2016,
            :cvc        =>  666
                    },).id
        response = StripeWrapper::Charge.create(
          :amount       =>  400,
          :card         =>  token,
          :description  => 'An invalid charge'
          )
        expect(response).to_not be_successful
      end

      it "returns the error message for declined charges", :vcr do
        Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
        token = Stripe::Token.create( 
          :card  => {
            :number     =>  '4000000000000002',
            :exp_month  =>  12,
            :exp_year   =>  2016,
            :cvc        =>  666
                    },).id
        response = StripeWrapper::Charge.create(
          :amount       =>  400,
          :card         =>  token,
          :description  => 'An invalid charge'
          )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end  
  end  
end