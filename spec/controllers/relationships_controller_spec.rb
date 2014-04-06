require 'spec_helper'

describe RelationshipsController do 

  describe "GET index" do
    it "sets @relationships to current user's following relationships" do
      jane = Fabricate(:user)
      set_current_user
      relationships = Fabricate(:relationship, follower: current_user, leader: jane)
      get :index
      expect(assigns(:relationships)).to eq([relationships])
    end

    it_behaves_like "require log-in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do

    it_behaves_like "require log-in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "deletes a following relationship" do
      jane = Fabricate(:user)
      set_current_user
      relationship = Fabricate(:relationship, follower: current_user, leader: jane)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "does only deletes the current user's following relationships" do
      jane = Fabricate(:user)
      set_current_user
      ralationship1 = Fabricate(:relationship, follower: current_user, leader: jane)
      relationship2 = Fabricate(:relationship, follower: jane, leader: current_user)
      delete :destroy, id: relationship2
      expect(Relationship.count).to eq(2)
    end

    it "redirects to the people page" do
      jane = Fabricate(:user)
      set_current_user
      relationship = Fabricate(:relationship, follower: current_user, leader: jane)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end
  end

  describe "POST create" do

    it_behaves_like "require log-in" do
      let(:action) { post :create, id: 1 }
    end    

    it "redirects to people page" do
      joe = Fabricate(:user)
      set_current_user
      post :create, id: joe.id
      expect(response).to redirect_to people_path
    end

    it "creates a following relationship" do
      joe = Fabricate(:user)
      set_current_user
      post :create, id: joe
      expect(Relationship.first.leader).to eq(joe)
    end

    it "does not create a relationship if it already exists" do
      joe = Fabricate(:user)
      set_current_user
      Relationship.create(leader: joe, follower: current_user)
      post :create, id: joe
      expect(Relationship.count).to eq(1)
    end

    it "doesnt create a relationship if a user tries to follow himself" do
      joe = Fabricate(:user)
      set_current_user(joe)
      post :create, id: joe
      expect(Relationship.count).to eq(0)
    end
  end
end