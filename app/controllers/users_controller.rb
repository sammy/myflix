class UsersController < ApplicationController
  before_action :check_session, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to sign_in_path
      AppMailer.sign_in_notification(@user).deliver
    else
      render :new
    end    
  end

  def show
    @user = User.find(params[:id])
  end

  def forgot_password

  end

  private

  def user_params
    params.require(:user).permit!
  end 
end
