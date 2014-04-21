class AppMailer < ActionMailer::Base

  def sign_in_notification(user)
    @user = user
    mail from: 'no-reply@myflix.com', to: @user.email, subject: 'Welcome to Myflix!'
  end

  def reset_password_notification(user)
    @user = user
    mail from: 'no-reply@myflix.com', to: @user.email, subject: 'Password reset'
  end

end