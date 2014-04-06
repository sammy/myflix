require 'spec_helper'

describe Relationship do 
  
  it { should validate_uniqueness_of(:leader_id).scoped_to(:follower_id) }

  describe "dont_add_self" do
    
    it "does not create a record with the same id both for leader and follower" do
      Relationship.create(leader_id: 2, follower_id: 2)
      expect(Relationship.count).to eq(0)
    end

    it "adds an error message" do
      relationship = Relationship.create(leader_id: 2, follower_id: 2)
      expect(relationship.errors.full_messages).to eq(["Follower and leader cant be the same person!"]) 
    end
  end

end