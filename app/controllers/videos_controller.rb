class VideosController < ApplicationController

  before_filter :check_session 

  def home
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @videos = Video.search_by_title(params[:search])
  end


end