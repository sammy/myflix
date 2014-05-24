require 'spec_helper'

describe UserRegistration do

  describe '#register' do
    context 'valid personal and payment data' do

      let(:charge) { double(:charge, successful?: true) }
      let(:user) { User.new(Fabricate.attributes_for(:user)) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "creates a new user in the database" do
        registration = UserRegistration.new(user, '12-xx-56', '').register
        expect(User.count).to eq(1)
      end

      it "sets the registration message" do
        registration = UserRegistration.new(user, '12-xx-56', '')
        registration.register
        expect(registration.message).to eq('You have registered successfully! You can now login.')        
      end

      it "sets the registration state to successful" do
        registration = UserRegistration.new(user, '12-xx-56', '')
        registration.register
        expect(registration.state).to eq(:success)
      end

      it "sends a registration email" do
        registration = UserRegistration.new(user, '12-xx-56', '').register
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "sends the email to the correct recipient" do
        registration = UserRegistration.new(user, '12-xx-56', '').register
        message = ActionMailer::Base.deliveries.last      
        message.to.should eq([user[:email]])
      end

      it "send an email with the correct content" do
        registration = UserRegistration.new(user, '12-xx-56', '').register
        message = ActionMailer::Base.deliveries.last 
        message.body.should include("Welcome to Myflix!")
      end

      it "should handle invitations" do
        UserRegistration.any_instance.should_receive(:handle_invitation)
        registration = UserRegistration.new(user, '12-xx-56', '').register
      end
    end

    context "valid personal data, invalid payment data" do

      let(:charge) { double(:charge, successful?: false, error_message: "Your card was declined.") }
      let(:user) { User.new(Fabricate.attributes_for(:user)) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "does not create a user in the database" do
        registration = UserRegistration.new(user, '12-xx-56', '').register
        expect(User.count).to eq(0)
      end

      it "sets the message attribute" do
        registration = UserRegistration.new(user, '12-xx-56', '')
        registration.register
        expect(registration.message).to eq("Your card was declined.")
      end
    end

    context 'invalid personal data' do

      let(:user) { User.new(full_name: 'Some One') }

      it "does not create a user" do
        registration = UserRegistration.new(user, '12-xx-56', '').register
        expect(User.count).to eq(0)
      end

      it "sets the message attribute" do
        registration = UserRegistration.new(user, '12-xx-56', '')
        registration.register
        expect(registration.message).to eq('Please check the error messages. Your personal information is not correct.')
      end
    end
  end

  describe 'handle_invitation' do

    let(:charge) { double(:charge, successful?: true) }
    let(:alice) { Fabricate(:user) }
    let(:invitation) { Fabricate(:invitation, recipient_name: 'Joe Doe', recipient_email: 'joe@doe.com', inviter_id: alice.id) }
    let(:user)  { User.new(full_name: invitation.recipient_name, email: invitation.recipient_email, password: 'secret') }

    before do
      StripeWrapper::Charge.should_receive(:create).and_return(charge)
    end

    context "with invitation token present" do

      it "makes the user follow the inviter" do
        registration = UserRegistration.new(user, '123-xx', invitation.token).register
        joe = User.last
        expect(joe.follows?(alice)).to be_true
      end

      it "makes the inviter follow the user" do
        registration = UserRegistration.new(user, '123-xx', invitation.token).register
        joe = User.last
        expect(alice.follows?(joe)).to be_true
      end

      it "expires the invitation upon acceptance" do
        registration = UserRegistration.new(user, '123-xx', invitation.token).register
        expect(Invitation.last.token).to be_nil
      end
    end
  end
end