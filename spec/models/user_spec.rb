require 'spec_helper'

describe User do
  it { should have_many(:reviews).order("created_at DESC") }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order("position") }
  

  describe "#queued_video?" do
    it "returns true if the video is already in the user's queue" do
      fake_user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: fake_user)
      expect(fake_user.queued_video?(video)).to be_true 
    end
    it "returns false if the video is not in the user's queue" do
      fake_user = Fabricate(:user)
      video = Fabricate(:video)
      expect(fake_user.queued_video?(video)).to be_false 
    end
  end
end