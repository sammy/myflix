require 'spec_helper'

describe Video do 
  it "saves itself" do
    video = Video.new(title: "Ghostbusters", description: "80's movie", small_cover_url: "ghostbusters.jpg", large_cover_url: "ghostbusters_large.jpg")
    video.save
    Video.first.title.should == "Ghostbusters"
  end
end