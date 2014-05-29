require "spec_helper"

describe 'Handle Failed Payments' do

  after { ActionMailer::Base.deliveries.clear }

  let(:event_data) do 
    {
      "id" => "evt_1047oV4Lt6GZHN3U24gqS0S1",
      "created" => 1401390472,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_1047oV4Lt6GZHN3UyvlarSCJ",
          "object" => "charge",
          "created" => 1401390472,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "eur",
          "refunded" => false,
          "card" => {
            "id" => "card_1047oU4Lt6GZHN3Uo4Uw75jD",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 8,
            "exp_year" => 2018,
            "fingerprint" => "zEvZz4UHwRNpozvN",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "customer" => "cus_47ge8K3rqzEQJS"
          },
          "captured" => false,
          "refunds" => [],
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_47ge8K3rqzEQJS",
          "invoice" => nil,
          "description" => "failed",
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_47oV42jxWlysDK"
}
  end

  it 'locks the users account' do
    user = Fabricate(:user, customer_token: 'cus_47ge8K3rqzEQJS' )
    post '/stripe_events', event_data
    retrieved_user = User.find_by(customer_token: 'cus_47ge8K3rqzEQJS')
    expect(retrieved_user.is_locked).to be_true
  end  
end