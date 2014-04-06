class RelationshipsController < ApplicationController
  before_action :check_session

  def index
    @relationships = current_user.following_relationships
  end
  
  def destroy
    @relationship = Relationship.find(params[:id])
    @relationship.destroy unless current_user != @relationship.follower
    redirect_to people_path
  end

  def create
    @relationship = Relationship.new(leader_id: params[:id], follower_id: current_user.id)
    if @relationship.save
      flash[:message] = "You are now following #{@relationship.leader.full_name}"
    else
      flash[:danger] = @relationship.errors.full_messages[0]
    end
    redirect_to people_path
  end

end