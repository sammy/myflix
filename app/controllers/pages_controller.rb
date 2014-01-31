class PagesController < ApplicationController

  def front
    redirect to home_path if logged_in?
  end

end