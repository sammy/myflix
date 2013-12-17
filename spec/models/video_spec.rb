require 'spec_helper'

describe Video do 
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe ".search_by_title" do
    Video.create(title: "Ghostbusters", description: "80's funny movie")
    Video.create(title: "I heart Huckabees", description: "Existential detectives at work")
    Video.create(title: "Ghost Rider", description: "Some description")
    match_exact = "Huckabees"
    match_many = "ghost"
    match_none = "Soutpark"
    match_one_partial = "bust"

    it "returns an empty array if there is no match" do
      expect(Video.search_by_title(match_none)).to eq []
    end

    it "returns an array of one video if there is an exact match" do
      expect(Video.search_by_title(match_exact)).to eq [Video.find(2)]
    end

    it "returns an array of one video if there is a partial match" do
      expect(Video.search_by_title(match_one_partial)).to eq [Video.find(1)]
    end

    it "returns an array of matching results ordered by created_at" do
      expect(Video.search_by_title(match_many)).to eq [Video.last, Video.first] 
      expect(Video.search_by_title(match_many)).to_not include Video.find(2)
    end 
  end

end

