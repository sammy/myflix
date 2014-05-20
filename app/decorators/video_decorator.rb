class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.reviews.any? ? "#{object.rating}/5.0" : "N/A"
  end
end