require 'spec_helper'

describe AdminController do

  describe '#ensure_admin' do
    it 'redirects to root_path if user is not an admin' do
      set_current_user
      expect(AdminController.ensure_admin).to redirect_to root_path
    end
  end
  
end