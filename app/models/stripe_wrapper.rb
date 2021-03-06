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
end