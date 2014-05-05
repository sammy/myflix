require 'spec_helper'

describe Invitation do 
  
  it { should belong_to(:inviter) }
  it { should validate_presence_of(:recipient_name) }
  it { should validate_presence_of(:recipient_email) }  

  describe '#generate_token' do
    it "auto creates a random token when invitation is saved" do
      invitation = Fabricate(:invitation)
      expect(Invitation.last.token).to eq(invitation.token)
    end
  end
end