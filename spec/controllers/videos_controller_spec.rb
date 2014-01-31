require 'spec_helper'

describe VideosController do 

  describe 'GET show' do
    
    context "with authenticated users" do    
      let(:video) { Fabricate(:video) } 
      before :each do 
        user = Fabricate(:user)
        session[:user_id] = user.id
        get :show, id: video.id
      end
      
      it "sets the @video instance variable" do
        expect(assigns(:video)).to eq(video)
      end
    end

    context "with non authenticated users" do
      it "redirects to the sign in page" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST search" do 
    
    context "with authenticated users" do
      it "sets the @videos instance variable" do
        video = Fabricate(:video, title: "The Hunt")
        session[:user_id] = Fabricate(:user).id
        post :search, search: "hun"
        expect(assigns(:videos)).to eq [video]
      end
    end

    context "with non authenticated users" do
      it "redirects to the sign-in page" do
        post :search, search: "hun"
        expect(response).to redirect_to sign_in_path
      end
    end

  end
end