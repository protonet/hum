class QueueController < ApplicationController

  def index
    puts "SESSION ID #{session_id}"
    @queue = Queue.list(session_id)
    render :layout => false
  end

  def add_to
    Queue.add(params[:id], session_id)
    render :nothing => true
  end

  def next_track
    id = Queue.remove(session_id)
    render :json => {'id' => (id ? id : '')}, :layout => false
  end

  def queue_has_tracks
    render :json => {'has_tracks' => (Queue.list(session_id).empty? ? 'false' : 'true')}, :layout => false
  end

end

