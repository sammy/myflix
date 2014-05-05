class InvitationsController < ApplicationController

  def new
    redirect_to sign_in_path unless logged_in?
    @invitation = Invitation.new
  end

  def create
    invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if invitation.save
      AppMailer.invite_user(invitation).deliver
      flash[:notice] = "Succesfully sent invitation to #{invitation.recipient_name}"
    else
      flash[:danger] = invitation.errors.full_messages[0].to_s
    end
    redirect_to new_invitation_path
  end

  private 

  def invitation_params
    params.required(:invitation).permit!
  end
end