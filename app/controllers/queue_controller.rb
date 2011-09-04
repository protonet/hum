class QueueController < ApplicationController

  def index
    @queue = Queue.list
    headers['Cache-Control'] = 'no-cache'
    render :layout => false
  end

  def add_to
    Queue.add(params[:id])
    puts "Queue is #{Queue.list}"
    render :nothing => true
  end

  def next_track
    id = Queue.remove
    headers['Cache-Control'] = 'no-cache'
    render :json => {'id' => (id ? id : '')}, :layout => false
  end

  def queue_has_tracks
    headers['Cache-Control'] = 'no-cache'
    render :json => {'has_tracks' => (Queue.list.empty? ? 'false' : 'true')}, :layout => false
  end

end

