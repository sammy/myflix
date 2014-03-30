require 'spec_helper'

describe QueueItem do  
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id).with_message("is already in the queue!")}
  it { should validate_numericality_of(:position).only_integer }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq(video.title)
    end
  end

  describe "#rating" do
    it "returns the video rating of the current user" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: user, video: video, rating: 3)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(3)
    end

    it "returns nil if there is no review" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(nil)
      
    end

  end

  describe "#rating=(new_rating)" do
    it "changes the review rating if a rating is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 3)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end
    it "clears the review rating if a rating is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 3)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = nil
      expect(Review.count).to eq(0)
    end
    it "creates a review rating if there is no rating present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 3
      expect(Review.first.rating).to eq(3)
    end
  end


  describe "#category_name" do
    it "returns the category name of the associated video" do
      category = Fabricate(:category, name: "Action")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Action")
    end
  end

  describe "#category" do
    it "should return the category of the associated video" do
      category = Fabricate(:category, name: "Action")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)      
    end
  end

end 