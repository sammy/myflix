require 'spec_helper'

describe 'Create payment on successful charge' do

  let(:event_data) do
          {
        "id" => "evt_1047f14Lt6GZHN3U3eZvQk27",
        "created" => 1401355191,
        "livemode" => false,
        "type" => "charge.succeeded",
        "data" => {
          "object" => {
            "id" => "ch_1047f14Lt6GZHN3UhyRGKz4i",
            "object" => "charge",
            "created" => 1401355191,
            "livemode" => false,
            "paid" => true,
            "amount" => 999,
            "currency" => "eur",
            "refunded" => false,
            "card" => {
              "id" => "card_1047f14Lt6GZHN3U4duwizbb",
              "object" => "card",
              "last4" => "4242",
              "type" => "Visa",
              "exp_month" => 5,
              "exp_year" => 2017,
              "fingerprint" => "XAf6tnqVRqNXRAzw",
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
              "customer" => "cus_47f1NsNCUO7p1J"
            },
            "captured" => true,
            "refunds" => [],
            "balance_transaction" => "txn_1047f14Lt6GZHN3UVRSKLuSh",
            "failure_message" => nil,
            "failure_code" => nil,
            "amount_refunded" => 0,
            "customer" => "cus_47f1NsNCUO7p1J",
            "invoice" => "in_1047f14Lt6GZHN3UlHosodiw",
            "description" => nil,
            "dispute" => nil,
            "metadata" => {},
            "statement_description" => "monthly charge"
          }
        },
        "object" => "event",
        "pending_webhooks" => 1,
        "request" => "iar_47f1DI2Kr6jHF8"
      }
  end

  it "creates a payment with the stripe webhook for successful charge" do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end 

  it "creates the payment associated with the user" do
    alice = Fabricate(:user, customer_token: "cus_47f1NsNCUO7p1J")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "created the payment with the amount" do
    alice = Fabricate(:user, customer_token: "cus_47f1NsNCUO7p1J")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end
  

end