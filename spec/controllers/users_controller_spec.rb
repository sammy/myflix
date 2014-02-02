require 'spec_helper'

describe UsersController do
  
  describe "GET new" do
    it "creates a new instance of the user object" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do

    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates a new user in the database" do
        expect(User.count).to eq(1)
      end

      it "redirects to the sign-in page" do
        expect(response).to redirect_to sign_in_path
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
  end
end