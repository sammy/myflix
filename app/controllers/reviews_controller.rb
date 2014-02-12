class ReviewsController < ApplicationController

  before_action :check_session

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new(review_params)
    if @review.save
      flash[:notice] = "Review succesfully added"
      redirect_to video_path(@video)
    else
      redirect_to sign_in_path
    end
  end

  protected

  def review_params
    params.require(:review).permit!
  end
end