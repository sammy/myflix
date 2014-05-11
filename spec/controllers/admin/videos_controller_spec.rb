require 'spec_helper'

describe Admin::VideosController do

  describe 'GET new' do

    it_behaves_like 'require log-in' do
      let(:action) { get :new }
    end

    it_behaves_like 'require admin log-in' do
      let(:action) { get :new }
    end

    it 'sets the @video instance variable' do
      set_current_user(nil, 'admin')
      get :new
      expect(assigns(:video)).to be_kind_of(Video)
    end
  end

  describe 'POST create' do

    it_behaves_like 'require log-in' do
      let(:action) { post :create }
    end

    it_behaves_like 'require admin log-in' do
      let(:action) { post :create }
    end

    context 'with valid input' do
        
       before { set_current_user(nil, 'admin') } 

      it 'redirects to new_admin_video_path' do
        small_cover = File.open("#{Rails.root}/app/assets/images/family_guy.jpg")
        post :create, video: {  title: Faker::Lorem.word, 
                                description: Faker::Lorem.sentence, 
                                small_cover: small_cover }
        expect(response).to redirect_to new_admin_video_path
      end

      it 'creates a new video in the database' do
        small_cover = File.open("#{Rails.root}/app/assets/images/family_guy.jpg")
        post :create, video: {  title: Faker::Lorem.word, 
                                description: Faker::Lorem.sentence, 
                                small_cover: small_cover }
        expect(Video.count).to eq(1)
      end

      it 'associates the video with the selected category' do
        category = Fabricate(:category)
        small_cover = File.open("#{Rails.root}/app/assets/images/family_guy.jpg")
        post :create, video: {  title: Faker::Lorem.word, 
                                description: Faker::Lorem.sentence, 
                                category_id: category.id,
                                image: small_cover }
        expect(Video.last.category).to eq(category)
      end

      it 'uploads the selected images to Amazon S3' do
        category = Fabricate(:category)
        small_cover = File.open(File.join(Rails.root, '/app/assets/images/family_guy.jpg'))
        large_cover = File.open(File.join(Rails.root, '/app/assets/images/monk_large.jpg'))
        post :create, video: {  title: 'An Rspec Video',
                                description: Faker::Lorem.sentence,
                                category_id: category.id, 
                                small_cover: small_cover,
                                large_cover: large_cover }
        expect(Video.last.small_cover.url).to_not be_nil
        expect(Video.last.large_cover.url).to_not be_nil
      end

      it 'displays a success message' do
        category = Fabricate(:category)
        small_cover = File.open("#{Rails.root}/app/assets/images/family_guy.jpg")
        post :create, video: {  title: Faker::Lorem.word, 
                                description: Faker::Lorem.sentence, 
                                category_id: category.id,
                                small_cover: small_cover }
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid input' do

      before { set_current_user(nil, 'admin') }

      it 'does not create a video' do
        category = Fabricate(:category)
        image = File.open("#{Rails.root}/app/assets/images/family_guy.jpg")
        post :create, video: {  description: Faker::Lorem.sentence,
                                category_id: category.id, 
                                image: image }
        expect(Video.count).to eq(0)
      end

      it 'renders the new template' do
        category = Fabricate(:category)
        image = File.open("#{Rails.root}/app/assets/images/family_guy.jpg")
        post :create, video: {  description: Faker::Lorem.sentence,
                                category_id: category.id, 
                                image: image }
        expect(response).to render_template :new
      end

      it 'sets the @video instance variable' do
        category = Fabricate(:category)
        image = File.open("#{Rails.root}/app/assets/images/family_guy.jpg")
        post :create, video: {  description: Faker::Lorem.sentence,
                                category_id: category.id, 
                                image: image } 
        expect(assigns(:video)).to be_present
      end

      it 'sets the flash error message' do
        category = Fabricate(:category)
        image = File.open("#{Rails.root}/app/assets/images/family_guy.jpg")
        post :create, video: {  description: Faker::Lorem.sentence,
                                category_id: category.id, 
                                image: image } 
        expect(flash[:error]).to be_present        
      end
    end
  end
end