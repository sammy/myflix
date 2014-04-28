class Invitation < ActiveRecord::Base
  belongs_to :inviter, :class_name => "User"

  validates_presence_of :recipient_name
  validates_presence_of :recipient_email

  before_create :generate_token


  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

end