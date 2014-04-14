require 'spec_helper'

describe ForgotPasswordsController do 
  
  describe "POST create" do

    context "with valid input" do 
      it "redirects to confirm password reset page" do
        forgetful_user = Fabricate(:user)
        post :create, email: forgetful_user.email
        expect(response).to redirect_to confirm_password_reset_path
      end
      it "generates a unique token" do
        forgetful_user = Fabricate(:user)
        post :create, email: forgetful_user.email
        expect(User.find_by_email(forgetful_user.email).token).to_not be_nil
      end
      it "sets an expiration date on the token" do
        forgetful_user = Fabricate(:user)
        post :create, email: forgetful_user.email
        expect(User.find_by_email(forgetful_user.email).token_expiration).to eq((forgetful_user.updated_at + 120.minutes).to_s)
      end
      it "emails the generated token to the user" do
        forgetful_user = Fabricate(:user)
        post :create, email: forgetful_user.email
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it "includes a password reset link in the email body" do
        forgetful_user = Fabricate(:user)
        post :create, email: forgetful_user.email
        last_delivery = ActionMailer::Base.deliveries.last
        last_delivery.body.should include(forgetful_user.reload.password_reset_link)
      end
    end

    context "with invalid input" do

      it "renders the new template" do
        post :create, email: "bla@bla.com"
        expect(response).to redirect_to forgot_password_path
      end

      it "displays a flash message" do
        post :create, email: "bla@bla.com"
        expect(flash[:danger]).to eq("User does not exist.")
      end
    end
  end

  describe "GET edit" do
    context "with a valid link" do

      it "shows the reset password page when token is still valid" do
        user = Fabricate(:user, token: "randomstring", token_expiration: Time.now + 1.hour)
        get :edit, {token: "randomstring"}
        expect(response).to render_template :edit 
      end

      it "assigns the user instance variable" do
        user = Fabricate(:user, token: "randomstring", token_expiration: Time.now + 1.hour)
        get :edit, {token: "randomstring"}
        expect(assigns(:user)).to eq(user)
      end
    end

    context "with invalid link" do

      it "redirects to new action when token is not valid" do
        user = Fabricate(:user, token: "randomstring")
        get :edit, {token: "false_randomstring"}
        expect(response).to redirect_to forgot_password_path
      end

      it "redirects to new action when token has expired" do
        user = Fabricate(:user, token: "randomstring", token_expiration: Time.now - 5.minutes)
        get :edit, {token: "randomstring"}
        expect(response).to redirect_to forgot_password_path
      end

      it "displays error message when token is not valid" do
        user = Fabricate(:user, token: "randomstring")
        get :edit, {token: "false_randomstring"}
        expect(flash[:danger]).to eq("Your password link is expired or cannot be found. Please try to reset you password again.")
      end

      it "displays an error message when the token has expired" do
        user = Fabricate(:user, token: "randomstring", token_expiration: Time.now - 5.minutes)
        get :edit, {token: "randomstring"}
        expect(flash[:danger]).to eq("Your password link is expired or cannot be found. Please try to reset you password again.")        
      end
    end
  end

  describe "POST update" do

    context "user can be found" do

      it "should redirect to the sign in page" do
        user = Fabricate(:user, token: "randomstring", token_expiration: Time.now + 1.hour)
        post :update, token: user.token
        expect(response).to redirect_to sign_in_path
      end

      it "sets the user instance variable" do
        user = Fabricate(:user, token: "randomstring", token_expiration: Time.now + 1.hour)
        post :update, token: user.token
        expect(assigns(:user)).to eq(user)
      end

      it "should update the users password" do
        user = Fabricate(:user, token: "randomstring", token_expiration: Time.now + 1.hour)
        old_password = user.reload.password
        post :update, token: user.token, password: 'my_new_password'
        expect(user.reload.password_digest).to_not eq(old_password)
      end

      it "should clear the users token" do
        user = Fabricate(:user, token: "randomstring", token_expiration: Time.now + 1.hour)
        old_password = user.reload.password
        post :update, token: user.token, password: 'my_new_password'
        expect(user.reload.token).to be_nil
      end
      
      it "should clear the users token_expiration" do
        user = Fabricate(:user, token: "randomstring", token_expiration: Time.now + 1.hour)
        old_password = user.reload.password
        post :update, token: user.token, password: 'my_new_password'
        expect(user.reload.token_expiration).to be_nil
      end

      it "should display a success message" do 
        user = Fabricate(:user, token: "randomstring", token_expiration: Time.now + 1.hour)
        old_password = user.reload.password
        post :update, token: user.token, password: 'my_new_password'
        expect(flash[:notice]).to eq("Succesfully reset password")
      end
    end

    context "user cannot be found" do

      it "redirects to new action when token is not valid" do
        user = Fabricate(:user, token: "randomstring")
        get :edit, {token: "false_randomstring"}
        expect(response).to redirect_to forgot_password_path
      end

      it "redirects to new action when token has expired" do
        user = Fabricate(:user, token: "randomstring", token_expiration: Time.now - 5.minutes)
        get :edit, {token: "randomstring"}
        expect(response).to redirect_to forgot_password_path
      end

      it "displays error message when token is not valid" do
        user = Fabricate(:user, token: "randomstring")
        get :edit, {token: "false_randomstring"}
        expect(flash[:danger]).to eq("Your password link is expired or cannot be found. Please try to reset you password again.")
      end

      it "displays an error message when the token has expired" do
        user = Fabricate(:user, token: "randomstring", token_expiration: Time.now - 5.minutes)
        get :edit, {token: "randomstring"}
        expect(flash[:danger]).to eq("Your password link is expired or cannot be found. Please try to reset you password again.")        
      end
    end
  end
end