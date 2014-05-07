require 'spec_helper'

describe Admin::VideosController do

  describe 'GET new' do

    it_behaves_like "require log-in" do
      let(:action) { get :new }
    end

    it 'sets the @video instance variable' do
      set_current_user(nil, 'admin')
      get :new
      expect(assigns(:video)).to be_kind_of(Video)
    end

    it 'redirects to home_path if user is not an admin' do
      set_current_user
      get :new
      expect(response).to redirect_to root_path
    end

    it 'displays a flash message if user is not admin' do
      set_current_user
      get :new
      expect(flash[:error]).to eq('Not authorized!')
    end
  end
end