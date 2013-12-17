require 'spec_helper'

describe Video do 
  it "saves itself" do
    video = Video.new(title: "Ghostbusters", description: "80's movie", small_cover_url: "ghost.jpg", large_cover_url: "ghost_large.jpg")
    video.save
    Video.first.title.should == "Ghostbusters"
  end
end