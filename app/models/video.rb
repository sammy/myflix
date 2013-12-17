class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, :description, presence: true

  def self.search_by_title(term)
    where("title LIKE ?", "%#{term}%")
  end

end