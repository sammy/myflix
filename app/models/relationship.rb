class Relationship < ActiveRecord::Base

  validates_uniqueness_of :leader_id, scope: [:follower_id]
  validates_presence_of :leader_id, :follower_id
  validate :dont_add_self
  belongs_to :user
  belongs_to :follower, class_name: "User"
  belongs_to :leader, class_name: "User"


  def dont_add_self
    errors.add(:follower, "and leader cant be the same person!") if leader_id == follower_id
  end

end