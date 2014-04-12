class AppMailer < ActionMailer::Base
  def sign_in_notification(user)
    @user = user
    mail from: 'no-reply@myflix.com', to: @user.email, subject: 'Welcome to Myflix!'
  end
end