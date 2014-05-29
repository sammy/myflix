class SessionsController < ApplicationController
  
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by email: params[:email]

    if user && user.authenticate(params[:password]) && user.is_locked != true
      flash[:notice] = "You have logged in"
      session[:user_id] = user.id
      redirect_to home_path
    elsif user && user.authenticate(params[:password]) && user.is_locked == true
      flash[:danger] = "Your account has been locked. Please contact support@myflix.com."
      render :new
    else
      flash[:danger] = "Incorrect username or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, alert: "You have signed out"
  end

end