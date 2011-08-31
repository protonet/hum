class QueueController < ApplicationController

  def index
    render :json => Queue.list, :layout => false
  end

  def add_track
    Queue.add(params[:id])
  end

  def next_track
    id = Queue.remove

    if id
      render :json => {'id' => id}, :layout => false
    else
      head :error
    end
  end

end

