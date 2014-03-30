require 'spec_helper'

describe Category do
  it { should have_many(:videos)}

  describe "#recent_videos" do
    let(:comedies) { Category.create(name: "comedies") }

   it "returns all videos in reverse chronological order by created_at" do 
    ghostbusters = Video.create(title: "Ghostbusters", description: "80's funny movie", created_at: 1.day.ago, category: comedies)
    ghost_rider = Video.create(title: "Ghost Rider", description: "Some description", created_at: 2.minutes.ago, category: comedies)
    expect(comedies.recent_videos).to eq [ghost_rider, ghostbusters]
   end

   it "returns all videos if there are less than 6 videos" do
    4.times { Video.create(title: "Ghost Rider", description: "Some description", created_at: 2.minutes.ago, category: comedies) }
    expect(comedies.recent_videos).to have(4).items
   end

   it "returns 6 videos if there more than 6 videos" do 
    8.times { Video.create(title: "Ghost Rider", description: "Some description", created_at: 2.minutes.ago, category: comedies) }
    expect(comedies.recent_videos).to have(6).items
   end

   it "returns the 6 most recent videos" do
    2.times { Video.create(title: "Ghost Rider", description: "Some description", created_at: 2.minutes.ago, category: comedies) }
    4.times { Video.create(title: "Ghostbusters", description: "80's funny movie", created_at: 1.day.ago, category: comedies) }
    huckabees = Video.create(title: "I heart Huckabees", description: "Existential detectives at work", created_at: 2.days.ago)
    expect(comedies.recent_videos).to_not include(huckabees)
   end

   it "returns an empty array if there are no videos" do
    expect(comedies.recent_videos).to eq []
   end
  end
end
