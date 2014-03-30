require 'spec_helper'

describe VideosController do 

  describe 'GET show' do
       
    let(:video) { Fabricate(:video) } 

    before :each do 
      set_current_user
      get :show, id: video.id
    end
    
    it "sets the @video instance variable" do
      expect(assigns(:video)).to eq(video)
    end

    it "sets the @reviews instance variable" do
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      expect(assigns(:reviews)).to match_array [review1, review2]
    end 
    
    it_behaves_like "require log-in" do
      let(:action) { get :show, id: video.id }
    end   
  end

  describe "POST search" do 
        
    it "sets the @videos instance variable" do
      video = Fabricate(:video, title: "The Hunt")
      set_current_user
      post :search, search: "hun"
      expect(assigns(:videos)).to eq [video]
    end
  
    it_behaves_like "require log-in" do
      let(:action) { post :search, search: "hun" }
    end
  end
end