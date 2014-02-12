class QueueItemsController < ApplicationController
  before_action :check_session
  def index
    @queue_items = current_user.queue_items
  end

end