class SessionsController < ApplicationController
  
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by email: params[:email]

    if user && user.authenticate(params[:password])
      flash[:notice] = "You have logged in"
      session[:user_id] = user.id
      redirect_to home_path
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