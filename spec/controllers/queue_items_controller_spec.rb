require 'spec_helper' 

describe QueueItemsController do 

  describe "GET index" do
  
    it "sets the queue_items instance variable for the current user" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, video_id: 2, user: user, position: 1)
      queue_item2 = Fabricate(:queue_item, video_id: 3, user: user, position: 2)
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

  describe "DELETE destroy" do

    it "redirects to the queue page" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: user)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "removes the item from the queue" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: user)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end 
    it "does not delete another user's queue item" do
      alice = Fabricate(:user)
      joe = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: alice)
      session[:user_id] = joe.id
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end
    it "normalizes the queue when items are deleted" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, video_id: 5, position: 1)
      queue_item2 = Fabricate(:queue_item, user: user, video_id: 6, position: 2)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end
    it "redirect to the sign_in_path for nonauthenticated users" do
      delete :destroy, id: 2
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST reorder" do
    context "with valid parameters" do
      it "redirects to the my_queue_path" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        southpark = Fabricate(:video, title: "Southpark")
        the_hunt = Fabricate(:video, title: "The Hunt")
        queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: southpark)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: the_hunt)
        post :reorder, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "reorders the queue" do 
        user = Fabricate(:user)
        session[:user_id] = user.id
        southpark = Fabricate(:video, title: "Southpark")
        the_hunt = Fabricate(:video, title: "The Hunt")
        queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: southpark, id: 1)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: the_hunt, id: 2)
        post :reorder, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(user.queue_items).to eq([queue_item2, queue_item1])
      end
      it "normalizes the position numbers" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        southpark = Fabricate(:video, title: "Southpark")
        the_hunt = Fabricate(:video, title: "The Hunt")
        queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: southpark)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: the_hunt)
        post :reorder, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(user.queue_items.map(&:position)).to eq([1,2])
      end
    end
    context "with invalid parameters" do
      it "redirects to my_queue_path" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        southpark = Fabricate(:video, title: "Southpark")
        the_hunt = Fabricate(:video, title: "The Hunt")
        queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: southpark)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: the_hunt)
        post :reorder, queue_items: [{id: queue_item1.id, position: "a"}, {id: queue_item2.id, position: "b"}]
        expect(response).to redirect_to my_queue_path
      end
      it "does not change the queue order" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        southpark = Fabricate(:video, title: "Southpark")
        the_hunt = Fabricate(:video, title: "The Hunt")
        queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: southpark)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: the_hunt)
        post :reorder, queue_items: [{id: queue_item1.id, position: "a"}, {id: queue_item2.id, position: "b"}]
        expect(user.queue_items).to eq([queue_item1, queue_item2])
      end
      it "displays an error message" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        southpark = Fabricate(:video, title: "Southpark")
        the_hunt = Fabricate(:video, title: "The Hunt")
        queue_item1 = Fabricate(:queue_item, user: user, position: 1, video: southpark)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: the_hunt)
        post :reorder, queue_items: [{id: queue_item1.id, position: "a"}, {id: queue_item2.id, position: "b"}]
        expect(flash[:danger]).to eq("List order should contain integer numbers")
      end
    end
    context "with unauthenticated user" do
      it "redirects to the sign_in_path" do
        southpark = Fabricate(:video, title: "Southpark")
        the_hunt = Fabricate(:video, title: "The Hunt")
        queue_item1 = Fabricate(:queue_item, position: 1, video: southpark)
        queue_item2 = Fabricate(:queue_item, position: 2, video: the_hunt)
        post :reorder, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to sign_in_path
      end
    end
    context "with queue items that do not belong to the current user" do
      it "does not change the order of the queue items" do
        john = Fabricate(:user)
        session[:user_id] = john.id
        kay = Fabricate(:user)
        southpark = Fabricate(:video, title: "Southpark")
        the_hunt = Fabricate(:video, title: "The Hunt")
        queue_item1 = Fabricate(:queue_item, position: 1, video: southpark, user: kay)
        queue_item2 = Fabricate(:queue_item, position: 2, video: the_hunt, user: kay)
        post :reorder, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(kay.queue_items).to eq([queue_item1, queue_item2])

      end

    end
  end  

end
