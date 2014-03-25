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
    if queue_item.user == current_user
      queue_item.destroy
      normalize_queue
    end
    redirect_to my_queue_path
  end

  def reorder
    begin
      update_queue_positions
      normalize_queue
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "List order should contain integer numbers"
    end
    redirect_to my_queue_path
  end

  private

  def set_position
    QueueItem.where("user_id = ?", session[:user_id]).count + 1
  end

  def update_queue_positions
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
       queue_item = QueueItem.find(queue_item_data["id"])
       queue_item.update!(position: queue_item_data["position"]) unless queue_item.user != current_user
      end
    end
  end

  def normalize_queue
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end

end 