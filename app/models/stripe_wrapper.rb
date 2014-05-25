module StripeWrapper
  class Charge
    attr_reader :error_message, :response
    def initialize(response: nil, error_message: nil)
      @response = response
      @error_message = error_message
    end

    def self.create(options={})
      begin
        Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
        response = Stripe::Charge.create(
                                        :amount       => options[:amount],
                                        :card         => options[:card],
                                        :currency     => 'usd',
                                        :description  => options[:description])
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end

  class Customer
    attr_reader :error_message, :response
    
    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
        response = Stripe::Customer.create(
                                            :description => options[:description],
                                            :card        => options[:card],
                                            :email       => options[:email],
                                            :plan        => "basic" )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
        response.present?
    end
  end
end
