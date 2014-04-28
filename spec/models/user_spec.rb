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

  describe "#password_reset_link" do
    it "generates a password reset url appended with user token" do
      user = Fabricate(:user, token: 'randomstring')
      expect(user.password_reset_link).to eq('http://localhost:3000/password_reset/randomstring')
    end
  end

  describe "#generate_token" do
    it "generates a token for the user" do
      user = Fabricate(:user)
      user.generate_token
      expect(user.reload.token).to_not be_nil
    end
    it "sets an expiration date for the token" do
      user = Fabricate(:user)
      user.generate_token
      expect(user.reload.token_expiration).to_not be_nil
    end
  end

  describe "#password_link_expired?" do
    it "returns true if the token_expiration date is in the past" do
      user = Fabricate(:user, token: "randomstring", token_expiration: Time.now - 5.minutes)
      expect(user.password_link_expired?).to be_true
    end
    it "returns false if the token_expiration date is in the future" do
      user = Fabricate(:user, token: "randomstring", token_expiration: Time.now + 5.minutes)
      expect(user.password_link_expired?).to be_false
    end
  end

  describe '#follows?' do
    it 'returns true if a user follows another user' do
      joe = Fabricate(:user)
      alice = Fabricate(:user)
      Fabricate(:relationship, leader_id: alice.id, follower_id: joe.id)
      expect(joe.follows?(alice)).to be_true
    end

    it 'returns false if the user does not follow another user' do
      joe = Fabricate(:user)
      alice = Fabricate(:user)
      expect(joe.follows?(alice)).to be_false
    end
  end

  describe '#follow(another_user)' do
    it 'follows the user passed as argument' do
      joe = Fabricate(:user)
      alice = Fabricate(:user)
      joe.follow(alice)
      expect(joe.follows?(alice)).to be_true
    end

    it 'does not follow one s self' do
      joe = Fabricate(:user)
      joe.follow(joe)
      expect(joe.follows?(joe)).to be_false
    end
  end
end