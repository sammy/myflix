class ForgotPasswordsController < ApplicationController

  def create
    user = User.find_by_email(params[:email])
    if user
      user.generate_token
      AppMailer.reset_password_notification(user).deliver
      redirect_to confirm_password_reset_path
    else
      redirect_to forgot_password_path
      flash[:danger] = "User does not exist."
    end
  end

  def edit
    @user = User.find_by_token(params[:token])
    check_token_validity(@user)
  end

  def update
    if @user = User.find_by_token(params[:token])
      ['password', 'token', 'token_expiration'].each do |column|
        @user.update_attribute(column, column == 'password' ? params[:password] : nil )
      end
      flash[:notice] = "Succesfully reset password"
      redirect_to sign_in_path
    else
      check_token_validity(@user)
    end
  end

  private

  def check_token_validity(user)
    if user.nil? || user.password_link_expired?
      redirect_to forgot_password_path
      flash[:danger] = "Your password link is expired or cannot be found. Please try to reset you password again."
    end
  end

end