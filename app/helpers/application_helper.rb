module ApplicationHelper

  def options_for_video_reviews(selected=nil)
    options_for_select([5,4,3,2,1].map { |n| [pluralize(n, "Star"), n]}, selected)
  end

  def gravatar_icon(email)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest("#{email}".downcase)}?s=40"
  end

end
