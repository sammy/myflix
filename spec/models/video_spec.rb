require 'spec_helper'

describe Video do 
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe ".search_by_title" do
    
    let(:ghostbusters) {Video.create(title: "Ghostbusters", description: "80's funny movie", created_at: 1.day.ago)}
    let(:huckabees) {Video.create(title: "I heart Huckabees", description: "Existential detectives at work", created_at: 2.days.ago)}
    let(:ghost_rider) {Video.create(title: "Ghost Rider", description: "Some description", created_at: 2.minutes.ago)}

    it "returns an empty array if there is no match" do
      expect(Video.search_by_title("no-match")).to eq []
    end

    it "returns an array of one video if there is an exact match" do
      expect(Video.search_by_title("Huckabees")).to eq [huckabees]
    end

    it "returns an array of one video if there is a partial match" do
      expect(Video.search_by_title("bust")).to eq [ghostbusters]
    end

    it "returns an array of matching results ordered by created_at" do
      expect(Video.search_by_title("ghost")).to eq [ghost_rider,ghostbusters] 
      expect(Video.search_by_title("ghost")).to_not include huckabees
    end 

    it "returns an empty array if the search term is an empty string" do
      expect(Video.search_by_title("")).to eq []
    end
  end

  

end

