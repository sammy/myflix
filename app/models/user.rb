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

  def name_id
    full_name.gsub(/\s+/, "")
  end

  def password_reset_link
    Rails.application.routes.url_helpers.password_reset_url + "/#{token}"
  end

  def generate_token
    token = SecureRandom.urlsafe_base64
    update_attribute('token', token)
    update_attribute('token_expiration', updated_at + 120.minutes)
  end

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def follow(another_user)
    following_relationships.create(leader: another_user) unless another_user == self
  end

  def password_link_expired?
    if Time.now > token_expiration
      true
    elsif Time.now < token_expiration || Time.now == token_expiration
      false
    end
  end

end