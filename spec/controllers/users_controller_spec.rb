require 'spec_helper'
require 'sidekiq/testing'

describe UsersController do
  
  describe "GET new" do
    it "creates a new instance of the user object" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do

    context "with valid input" do

      it "creates a new user in the database" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirects to the sign-in page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'with invitation present' do

      it 'makes the user follow the inviter' do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, recipient_name: 'Joe Doe', recipient_email: 'joe@doe.com', inviter_id: alice.id)
        post :create, user: {full_name: invitation.recipient_name, email: invitation.recipient_email, password: 'password'}, invitation: {token: invitation.token}
        joe = User.last
        expect(joe.follows?(alice)).to be_true
      end

      it 'makes the inviter follow the user' do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, recipient_name: 'Joe Doe', recipient_email: 'joe@doe.com', inviter_id: alice.id)
        post :create, user: {full_name: invitation.recipient_name, email: invitation.recipient_email, password: 'password'}, invitation: {token: invitation.token}
        joe = User.last
        expect(alice.follows?(joe)).to be_true
      end

      it 'expires the invitation upon acceptance' do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, recipient_name: 'Joe Doe', recipient_email: 'joe@doe.com', inviter_id: alice.id)
        post :create, user: {full_name: invitation.recipient_name, email: invitation.recipient_email, password: 'password'}, invitation: {token: invitation.token}
        expect(Invitation.last.token).to be_nil
      end
    end

    context "with invalid input" do 
      it "renders the :new template if no email is present" do
        post :create, user: { full_name: Faker::Name.name, password_digest: 'secret'}
        expect(response).to render_template :new 
      end
      it "renders the sign-in page if no full_name is present" do
        post :create, user: { email: Faker::Internet.email, password_digest: 'secret'}
        expect(response).to render_template :new 
      end
      it "renders the sign-in page if no password is present" do
        post :create, user: { full_name: Faker::Name.name, email: Faker::Internet.email}
        expect(response).to render_template :new 
      end
    end

    context "email sending" do
      
      it "sends out an email" do
        post :create, user: Fabricate.attributes_for(:user)
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "sends the email to the correct recipient" do
        user = Fabricate.attributes_for(:user)
        post :create, user: user
        message = ActionMailer::Base.deliveries.last      
        message.to.should eq([user[:email]])
      end

      it "sends the email with the correct content" do
        user = Fabricate.attributes_for(:user)
        post :create, user: user
        message = ActionMailer::Base.deliveries.last
        message.body.should include("Welcome to Myflix!")
      end
    end 

  end

  describe "GET show" do
    it_behaves_like "require log-in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets the user instance variable" do
      set_current_user
      user = Fabricate(:user)
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "GET register_with_token" do

    it "sets the invitation variable" do
      invitation = Fabricate(:invitation)
      get :register_with_token, token: invitation.token
      expect(invitation).to be_present
    end

    it "sets the @user instance variable with recipients name" do
      invitation = Fabricate(:invitation)
      get :register_with_token, token: invitation.token
      expect(assigns(:user).full_name).to eq(invitation.recipient_name)
    end

    it 'sets @invitation instace variable' do
      invitation = Fabricate(:invitation)
      get :register_with_token, token: invitation.token
      expect(assigns(:invitation).token).to eq(invitation.token)      
    end 

    it "sets the @user instance variable with recipients email" do
      invitation = Fabricate(:invitation)
      get :register_with_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it 'redirects to register_with_token_path if the token is invalid' do
      get :register_with_token, token: 'someRandomToken'
      expect(response).to redirect_to register_path      
    end

    it 'displays an error message if the token is invalid' do
      get :register_with_token, token: 'someRandomToken'
      expect(flash[:danger]).to eq("Your token has expired")
    end
  end
end