require 'spec_helper'

describe SessionsController do
  
  describe "GET new" do
    context "with authenticated user" do
      it "redirects to home_path" do
        set_current_user
        get :new
        expect(response).to redirect_to home_path
      end
    end
    
    context "without authenticated user" do
      it "displays the sign_in page" do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do

    context "with valid credentials" do
      let!(:a_user) { Fabricate(:user, email: "joe@doe.com", password: "secret") }
      
      before do
        post :create, email: "joe@doe.com", password: "secret"
      end

      it "sets the session[:user_id]" do
        expect(session[:user_id]).to eq(a_user.id)
      end

      it "redirects to home_path" do
        expect(response).to redirect_to home_path
      end

      it "displays a log in message" do
        expect(flash[:notice]).to eq("You have logged in")
      end
    end

    context "without invalid credentials" do

      before do
        post :create, email: "joe@doe.com", password: "secret"
      end

      it "displays a warning message" do
        expect(flash[:danger]).to eq("Incorrect username or password")
      end

      it "renders the sign-in page" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET destroy" do
    before do
      get :destroy
    end

    it "resets the session" do
      expect(session[:user_id]).to eq(nil)
    end

    it "redirects to root path" do
      expect(response).to redirect_to root_path
    end

    it "displays an informational message" do
      expect(flash[:alert]).to eq("You have signed out")
    end
  end
end