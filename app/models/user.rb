class User < ActiveRecord::Base
  has_many :queue_items, -> { order 'position' }
  has_many :reviews, -> { order 'created_at DESC' }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id  
  has_many :followers, :through => :relationships
  has_many :leaders, :through => :relationships
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_secure_password validations: false

  def normalize_queue
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end
end