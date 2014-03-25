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

  def category_name
    video.category.name
  end



end