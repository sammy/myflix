require 'spec_helper'

describe Video do 
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe ".search_by_title" do
    it "returns an array of matching results ordered by title" do
      Video.create(title: "Ghostbusters", description: "80's funny movie")
      Video.create(title: "I heart Huckabees", description: "Existential detectives at work")
      Video.create(title: "Ghost Rider", description: "Some description")
      search_term = "ghost"
      expect(Video.search_by_title(search_term)).to eq [Video.last, Video.first] 
      expect(Video.search_by_title(search_term)).to_not include Video.find(2)

    end 
  end

end

