class Invitation < ActiveRecord::Base
  belongs_to :user, :class_name => "User", :foreign_key => "inviter_id"

  validates_presence_of :recipient_name
  validates_presence_of :recipient_email

end