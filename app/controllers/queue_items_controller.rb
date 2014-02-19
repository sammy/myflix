class QueueItemsController < ApplicationController
  before_action :check_session
  
  def index
    @queue_items = current_user.queue_items
  end

  def create
    @queue_item = QueueItem.new(video_id: params[:video_id], user_id: current_user.id, position: set_position)
    if @queue_item.save
      redirect_to my_queue_path
    else
      flash[:danger] = ""
      @queue_item.errors.full_messages.each { |err| flash[:danger] << err }
      redirect_to :back
    end
  end 

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy unless queue_item.user != current_user
    # queue_item.destroy
    redirect_to my_queue_path
  end


  private

  def set_position
    QueueItem.where("user_id = ?", session[:user_id]).count + 1
  end

end 