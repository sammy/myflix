class UsersController < ApplicationController
  before_action :check_session, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
      token = params[:stripeToken]
      charge = StripeWrapper::Charge.create(
              :amount => 999, # amount in cents
              :card => token,
              :description => "This is a payment from the #{@user.full_name}"
              )
      if charge.successful?
        @user.save
        handle_invitation
        flash[:success] = 'You have registered successfully!'
        redirect_to sign_in_path
        AppMailer.sign_in_notification(@user).deliver
      else
        flash[:error] = charge.error_message
        render :new
      end
    else
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

  def handle_invitation
    if !params[:invitation][:token].blank?
        invitation = Invitation.find_by(token: params[:invitation][:token])
        inviter = invitation.inviter
        @user.follow(inviter)
        inviter.follow(@user)
        invitation.update_column(:token, nil)
      end 
  end
end
