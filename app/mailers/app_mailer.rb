class AppMailer < ActionMailer::Base

  def sign_in_notification(user)
    @user = user
    mail from: 'no-reply@myflix.com', to: recipient(@user.email), subject: 'Welcome to Myflix!'
  end

  def reset_password_notification(user)
    @user = user
    mail from: 'no-reply@myflix.com', to: recipient(@user.email), subject: 'Password reset'
  end

  def invite_user(invitation)
    @invitation = invitation
    mail from: 'no-reply@myflix.com', to: recipient(@invitation.recipient_email) , subject: "#{@invitation.inviter.full_name} has invited you to MyFlix!"
  end

  def notify_of_failed_payment(user,card)
    @card = card
    @user = user
    mail from: 'billing@myflix.com', to: recipient(@user.email), subject: "Account locked"
  end

  private

  def recipient(user)
    Rails.env.production? || Rails.env.test? ? user : 'flouts@gmail.com'
  end
end