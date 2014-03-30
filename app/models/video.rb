class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order "created_at DESC" }
  
  validates :title, :description, presence: true

  def self.search_by_title(term)
    return [] if term.blank?
    where("title LIKE ?", "%#{term}%").order("created_at DESC")
  end

  def title_id
    title.gsub(/\s+/, "")
  end

  def in_queue_of?(user)
    user.queue_items.exists?
  end

end