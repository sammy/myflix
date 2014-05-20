require 'spec_helper'

describe InvitationsController do
  
  describe 'GET new' do
    
    it "should render new template if user is signed in" do
      set_current_user
      get :new
      expect(response).to render_template :new
    end
    
    it "should redirect to sign_in_path if user is not logged in" do
      get :new
      expect(response).to redirect_to sign_in_path
    end

    it "should initiate a new invitation object" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_kind_of(Invitation)
    end
  end


  describe 'POST create' do
    
    context "with valid input" do  
      
      after { ActionMailer::Base.deliveries.clear }

      it "should send an email to the invited person" do
        set_current_user
        post :create, invitation: { recipient_name: 'Joe Doe', recipient_email: 'joe.doe@joe.com', message: 'Check this out!' }
        expect(ActionMailer::Base.deliveries).to_not be_empty
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe.doe@joe.com"])
      end

      it "creates an invitation" do
        set_current_user
        post :create, invitation: { recipient_name: 'Joe Doe', recipient_email: 'joe.doe@joe.com', message: 'Check this out!' }
        expect(Invitation.count).to eq(1)
      end

      it "should redirect to the invitations_path" do
        set_current_user
        post :create, invitation: { recipient_name: 'Joe Doe', recipient_email: 'joe.doe@joe.com', message: 'Check this out!', inviter_id: current_user.id }
        expect(response).to redirect_to new_invitation_path       
      end

      it "should include a link to Myflix in the email body" do
        set_current_user
        post :create, invitation: { recipient_name: 'Joe Doe', recipient_email: 'joe.doe@joe.com', message: 'Check this out!', inviter_id: current_user.id }
        email = ActionMailer::Base.deliveries.first
        expect(email.body).to include("Take me to Myflix")        
      end

      it "should display a message that invitation has been sent" do
        set_current_user
        post :create, invitation: { recipient_name: 'Joe Doe', recipient_email: 'joe.doe@joe.com', message: 'Check this out!', inviter_id: current_user.id }
        expect(flash[:notice]).to eq('Succesfully sent invitation to Joe Doe')
      end
    end

    context "with invalid input" do

      after { ActionMailer::Base.deliveries.clear }

      it "should redirect to invitations_path" do
        set_current_user
        post :create, invitation: { recipient_email: 'joe.doe@joe.com', message: 'Check this out!', inviter_id: current_user.id }
        expect(response).to redirect_to new_invitation_path
      end

      it "does not create a new invitation" do
        set_current_user
        post :create, invitation: { recipient_email: 'joe.doe@joe.com', message: 'Check this out!', inviter_id: current_user.id }
        expect(Invitation.count).to eq(0)
      end
      
      it "should not send an email if name is not filled in" do
        set_current_user
        post :create, invitation: { recipient_email: 'joe.doe@joe.com', message: 'Check this out!', inviter_id: current_user.id }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "should display an error message if name is not filled in" do
        set_current_user
        post :create, invitation: { recipient_email: 'joe.doe@joe.com', message: 'Check this out!', inviter_id: current_user.id }
        expect(flash[:danger]).to eq("Recipient name can't be blank")
      end
      
      it "should not send an email if email is not filled in" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Doe", message: 'Check this out!', inviter_id: current_user.id }
        expect(ActionMailer::Base.deliveries).to be_empty 
      end

      it "should display an error message if email is not filled in" do
        set_current_user
        post :create, invitation: { recipient_name: 'Joe Doe', message: 'Check this out!', inviter_id: current_user.id }
        expect(flash[:danger]).to eq("Recipient email can't be blank")
      end

      it "should redirect to new_invitation_path" do
        set_current_user
        post :create, invitation: { recipient_name: 'Joe Doe', message: 'Check this out!', inviter_id: current_user.id }
        expect(response).to redirect_to new_invitation_path
      end
    end
  end
end