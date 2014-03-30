class QueueItem < ActiveRecord::Base
  validates_uniqueness_of :video_id, scope: :user_id, :message => "is already in the queue!"
  validates_numericality_of :position, only_integer: true
  belongs_to :user
  belongs_to :video
  
  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end

  def rating=(new_rating)
    if review && new_rating.to_i.between?(1,5)
      review.attributes = {rating: new_rating}
      review.save(validate: false)
    elsif review && new_rating.blank?
      review.destroy
    elsif review.nil?
      review = Review.new(user_id: user.id, video_id: video.id, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category_name
    video.category.name
  end

  private

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first 
  end
end