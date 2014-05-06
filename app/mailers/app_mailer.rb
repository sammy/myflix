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

  private

  def recipient(user)
    Rails.env.production? ? user : 'flouts@gmail.com'
  end
end