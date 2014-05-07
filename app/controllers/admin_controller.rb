class AdminController < ApplicationController
  before_filter :check_session
  before_filter :ensure_admin

  def ensure_admin
    unless current_user.is_admin
      flash[:error] = "Not authorized!"
      redirect_to root_path
    end
  end
end