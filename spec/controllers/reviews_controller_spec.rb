require 'spec_helper'

describe ReviewsController do 
    
  describe "POST create" do

    context "with authenticated user" do
      let(:user) { Fabricate(:user)}
      let(:video) { Fabricate(:video)}
      before { session[:user_id] = user.id }

      it "should save the review to the database" do
        post :create, video_id: video.id, review: {content: Faker::Lorem.paragraph(1), rating: 3, user_id: user.id}
        expect(Review.count).to eq(1)
      end
      it "should associate the review with the user" do
        post :create, video_id: video.id, review: {content: Faker::Lorem.paragraph(1), rating: 3, user_id: user.id}
        expect(Review.first.user_id).to eq(user.id)
      end
      it "should display a success message" do
        post :create, video_id: video.id, review: {content: Faker::Lorem.paragraph(1), rating: 3, user_id: user.id}
        expect(flash[:notice]).to eq("Review succesfully added")
      end
      it "should not save an empty review" do
        post :create, video_id: video.id, review: {rating: 3, user_id: user.id}
        expect(Review.count).to eq(0)
      end
    end


    context "without authenticated user" do
      let(:user) { Fabricate(:user)}
      let(:video) { Fabricate(:video)}
      before { post :create, video_id: video.id, review: {content: Faker::Lorem.paragraph(1), rating: 3 }
}
      it "should not save to the database" do
        expect(Review.count).to eq(0)
      end
      it "should redirect to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end
        
  end

end