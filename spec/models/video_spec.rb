require 'spec_helper'

describe Video do 
  it "saves itself" do
    video = Video.new(title: "Ghostbusters", description: "80's movie", small_cover_url: "ghostbusters.jpg", large_cover_url: "ghostbusters_large.jpg")
    video.save
    Video.first.title.should == "Ghostbusters"
  end

  it "belongs to category" do
    drama = Category.create(name: "Drama", description: "Dramatic!?")
    monk = Video.create(title: "Monk", description: "Some description", category: drama)
    expect(monk.category).to eq(drama)
  end
end