require 'spec_helper'

describe Video do 
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe ".search_by_title" do
    it "returns an array of matching results" do
      Video.create(title: "Ghostbusters", description: "80's funny movie")
      Video.create(title: "I  ghost heart Huckabees", description: "Existential detectives at work")
      Video.create(title: "Ghost Rider", description: "Some description")
      search_term = "ghost"
      expect(Video.search_by_title(search_term)).to eq [Video.first, Video.last] 

    end 
  end

end

