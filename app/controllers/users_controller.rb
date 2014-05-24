class UsersController < ApplicationController
  before_action :check_session, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    registration = UserRegistration.new(@user, params[:stripeToken], params[:invitation][:token]).register

    if registration.successful?
      flash[:success] = registration.message 
      redirect_to sign_in_path
    elsif registration.failed?
      flash[:danger] = registration.message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def register_with_token
    @invitation = Invitation.find_by(token: params[:token])
    if @invitation
      @user = User.new(full_name: @invitation.recipient_name, email: @invitation.recipient_email)
      render :new
    else
      flash[:danger] = "Your token has expired"
      redirect_to register_path
    end
  end

  private

  def user_params
    params.require(:user).permit!
  end
end
