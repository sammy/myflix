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

    context "successful registration" do

      it "redirects to the sign-in page" do
        registration = double(  :new_registration,
                                :successful? => true,
                                :message => 'You have registered successfully! You can now login.'
                             )
        UserRegistration.any_instance.should_receive(:register).and_return(registration)
        post :create, user: Fabricate.attributes_for(:user), invitation: { token: '' }
        expect(response).to redirect_to sign_in_path
      end
    

      it "dispays a flash success message" do
        registration = double(  :new_registration,
                                  :successful? => true,
                                  :message => 'You have registered successfully! You can now login.'
                               )
        UserRegistration.any_instance.should_receive(:register).and_return(registration)
        post :create, user: Fabricate.attributes_for(:user), invitation: { token: '' }
        expect(flash[:success]).to eq('You have registered successfully! You can now login.')  
      end
    end

    context "with valid personal data and invalid payment data" do

      it "renders the new template" do
        registration = double(  :new_registration,
                                :successful? => false,
                                :failed? => true,
                                :message => 'Your card was declined.'
                              )
        UserRegistration.any_instance.should_receive(:register).and_return(registration)
        post :create, user: Fabricate.attributes_for(:user), invitation: { token: '' }
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        registration = double(  :new_registration,
                                :successful? => false,
                                :failed? => true,
                                :message => 'Your card was declined.'
                              )
        UserRegistration.any_instance.should_receive(:register).and_return(registration)
        post :create, user: Fabricate.attributes_for(:user), invitation: { token: '' }
        expect(flash[:danger]).to eq('Your card was declined.')
      end
    end

    context "with invalid personal data" do

      it "renders the new template" do
        registration = double(  :new_registration,
                                :successful? => false,
                                :failed? => true,
                                :message => 'Please check the error messages. Your personal information is not correct.'
                              )
        UserRegistration.any_instance.should_receive(:register).and_return(registration)
        post :create, user: { full_name: 'Some One' }, invitation: { token: '' }
        expect(response).to render_template :new
      end

      it "sets the flash[:error] message" do
        registration = double(  :new_registration,
                                :successful? => false,
                                :failed? => true,
                                :message => 'Please check the error messages. Your personal information is not correct.'
                              )
        UserRegistration.any_instance.should_receive(:register).and_return(registration)
        post :create, user: {full_name: 'Some One'}, invitation: { token: '' }
        expect(flash[:danger]).to eq('Please check the error messages. Your personal information is not correct.')
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