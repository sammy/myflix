class UserRegistration
  attr_reader :user, :stripetoken, :invitationtoken
  attr_accessor :message, :state

  def initialize(user, stripeToken, invitationtoken)
    @user = user
    @stripetoken = stripeToken
    @invitationtoken = invitationtoken
    @message = ''
    @state = :neutral
  end

  def register
    if @user.valid?
      customer = StripeWrapper::Customer.create(:decription => "#{@user.full_name}-#{@user.email}", :card => stripeToken)
      # charge = StripeWrapper::Charge.create(:amount => 999, :card => stripetoken, :description => "Registration payment from #{user.full_name}")
      if customer.created?
        StripeWrapper::Subscription.create(:customer => customer)
      if charge.successful?
        @user.save
        handle_invitation
        self.message = 'You have registered successfully! You can now login.'
        AppMailer.sign_in_notification(user).deliver
        self.state = :success
        self
      else
        self.message = charge.error_message
        self.state = :failure
        self
      end
    else 
      self.message = "Please check the error messages. Your personal information is not correct."
      self.state = :failure
      self
    end
  end

  def successful?
    state == :success
  end

  def failed?
    state == :failure
  end
  
  private

  def handle_invitation
    if !invitationtoken.blank?
      invitation = Invitation.find_by(token: invitationtoken)
      inviter = invitation.inviter
      user.follow(inviter)
      inviter.follow(user)
      invitation.update_column(:token, nil)
    end
  end
end