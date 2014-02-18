require 'spec_helper' 

describe QueueItemsController do 

  describe "GET index" do
  
    it "sets the queue_items instance variable for the current user" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1,queue_item2])
    end

    it "redirects to the sign in page for non authenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end 
  end

  describe "POST create" do
    context "with authenticated user" do
      let!(:video) { Fabricate(:video, title: "Huckabees") }
      let!(:video1) { Fabricate(:video, title: "Southpark") }
      let!(:user) { Fabricate(:user) }

      it "adds the selected video to the queue items" do
        session[:user_id] = user.id
        post :create, user: user, video_id: video.id
        expect(QueueItem.first.video_title).to eq("Huckabees")
      end
      it "sets the order to the last one" do
        session[:user_id] = user.id
        post :create, user: user, video_id: video.id
        post :create, user: user, video_id: video1.id        
        expect(QueueItem.last.position).to eq(2)
      end
      it "redirects to my_queue_path" do 
        session[:user_id] = user.id
        post :create, user: user, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end
    end
    context "without authenticated user" do
      it "redirects to the sign_in page" do
        post :create
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end