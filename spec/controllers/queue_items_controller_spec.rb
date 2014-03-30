require 'spec_helper' 

describe QueueItemsController do 

  describe "GET index" do
  
    it "sets the queue_items instance variable for the current user" do
      set_current_user
      queue_item1 = Fabricate(:queue_item, video_id: 2, user: current_user, position: 1)
      queue_item2 = Fabricate(:queue_item, video_id: 3, user: current_user, position: 2)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1,queue_item2])
    end

    it_behaves_like "require log-in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    let!(:video) { Fabricate(:video, title: "Huckabees") }
    let!(:video1) { Fabricate(:video, title: "Southpark") }
    before { set_current_user }

    it "adds the selected video to the queue items" do
      post :create, user: current_user, video_id: video.id
      expect(QueueItem.first.video_title).to eq("Huckabees")
    end
    it "sets the order to the last one" do
      post :create, user: current_user, video_id: video.id
      post :create, user: current_user, video_id: video1.id        
      expect(QueueItem.last.position).to eq(2)
    end
    it "redirects to my_queue_path" do 
      post :create, user: current_user, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it_behaves_like "require log-in" do
      let(:action) { post :create }
    end
  end

  describe "DELETE destroy" do
    before { set_current_user }

    it "redirects to the queue page" do
      queue_item = Fabricate(:queue_item, user: current_user)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "removes the item from the queue" do
      queue_item = Fabricate(:queue_item, user: current_user)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end 

    it "does not delete another user's queue item" do
      alice = Fabricate(:user)
      joe = current_user
      queue_item = Fabricate(:queue_item, user: alice)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it "normalizes the queue when items are deleted" do
      queue_item1 = Fabricate(:queue_item, user: current_user, video_id: 5, position: 1)
      queue_item2 = Fabricate(:queue_item, user: current_user, video_id: 6, position: 2)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end

    it_behaves_like "require log-in" do
      let(:action) { delete :destroy, id: 2 }
    end
  end

  describe "POST reorder" do
    before { set_current_user }
    let(:southpark) { Fabricate(:video, title: "Southpark") }
    let(:the_hunt) { Fabricate(:video, title: "The Hunt") }
    let(:queue_item1) { Fabricate(:queue_item, user: current_user, position: 1, video: southpark) }
    let(:queue_item2) { Fabricate(:queue_item, user: current_user, position: 2, video: the_hunt) }
    context "with valid parameters" do
      it "redirects to the my_queue_path" do
        post :reorder, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "reorders the queue" do 
        post :reorder, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(current_user.queue_items).to eq([queue_item2, queue_item1])
      end
      it "normalizes the position numbers" do
        post :reorder, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(current_user.queue_items.map(&:position)).to eq([1,2])
      end
    end
    context "with invalid parameters" do
      it "redirects to my_queue_path" do
        post :reorder, queue_items: [{id: queue_item1.id, position: "a"}, {id: queue_item2.id, position: "b"}]
        expect(response).to redirect_to my_queue_path
      end
      it "does not change the queue order" do
        post :reorder, queue_items: [{id: queue_item1.id, position: "a"}, {id: queue_item2.id, position: "b"}]
        expect(current_user.queue_items).to eq([queue_item1, queue_item2])
      end
      it "displays an error message" do
        post :reorder, queue_items: [{id: queue_item1.id, position: "a"}, {id: queue_item2.id, position: "b"}]
        expect(flash[:danger]).to eq("List order should contain integer numbers")
      end
    end
    context "with unauthenticated user" do
      it "redirects to the sign_in_path" do
        clear_current_user
        queue_item1 = Fabricate(:queue_item, position: 1, video: southpark)
        queue_item2 = Fabricate(:queue_item, position: 2, video: the_hunt)
        post :reorder, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to sign_in_path
      end
    end
    context "with queue items that do not belong to the current user" do
      it "does not change the order of the queue items" do
        john = current_user
        kay = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, position: 1, video: southpark, user: kay)
        queue_item2 = Fabricate(:queue_item, position: 2, video: the_hunt, user: kay)
        post :reorder, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(kay.queue_items).to eq([queue_item1, queue_item2])
      end
    end
  end  
end
