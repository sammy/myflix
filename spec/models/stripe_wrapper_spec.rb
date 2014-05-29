require 'spec_helper'

describe StripeWrapper do

  let(:valid_token) do
    Stripe::Token.create(
                          :card  => {
                          :number     =>  '4242424242424242',
                          :exp_month  =>  12,
                          :exp_year   =>  2016,
                          :cvc        =>  666
                    }).id
  end

  let(:invalid_token) do
    Stripe::Token.create( 
          :card  => {
            :number     =>  '4000000000000002',
            :exp_month  =>  12,
            :exp_year   =>  2016,
            :cvc        =>  666
                    }).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      it "charges the card succesfully", :vcr do
        Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
        response = StripeWrapper::Charge.create(
          :amount       =>  400,
          :card         =>  valid_token,
          :description  => 'A valid charge'
          )
        expect(response).to be_successful
      end

      it "makes a card declined charge", :vcr do
        Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
        response = StripeWrapper::Charge.create(
          :amount       =>  400,
          :card         =>  invalid_token,
          :description  => 'An invalid charge'
          )
        expect(response).to_not be_successful
      end

      it "returns the error message for declined charges", :vcr do
        Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
        token = 
        response = StripeWrapper::Charge.create(
          :amount       =>  400,
          :card         =>  invalid_token,
          :description  => 'An invalid charge'
          )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end  
  end

  describe StripeWrapper::Customer do
    describe ".create" do

      it "creates a customer in Stripe" do
        user = User.new(Fabricate.attributes_for(:user))
        Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
        response = StripeWrapper::Customer.create(
          :description  => "#{user.full_name} - #{user.email}",
          :email        => "#{user.email}",
          :card         => valid_token)
        # binding.pry
        expect(response).to be_successful
      end

      it "has a customer_token" do
        user = User.new(Fabricate.attributes_for(:user))
        Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
        response = StripeWrapper::Customer.create(
          :description  => "#{user.full_name} - #{user.email}",
          :email        => "#{user.email}",
          :card         => valid_token)
        customer_token = response.response.id
        expect(response.customer_token).to eq(customer_token)
      end

      it "returns an error if the customer cannot be created" do
        user = User.new(Fabricate.attributes_for(:user))
        Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
        response = StripeWrapper::Customer.create(
          :description  => "#{user.full_name} - #{user.email}",
          :email        => "#{user.email}",
          :card         => invalid_token)
        expect(response).to_not be_successful
      end

      it "returns an error message for a declined card" do
        user = User.new(Fabricate.attributes_for(:user))
        Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
        response = StripeWrapper::Customer.create(
          :description  => "#{user.full_name} - #{user.email}",
          :email        => "#{user.email}",
          :card         => invalid_token)
        expect(response.error_message).to eq('Your card was declined.')
      end

    end
  end  
end