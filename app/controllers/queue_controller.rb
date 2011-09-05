class QueueController < ApplicationController

  def index
    puts "SESSION ID #{session_cache_key}"
    @queue = Queue.list(session_cache_key)
    render :layout => false
  end

  def add_to
    puts "SESSION ID #{session_cache_key}"
    Queue.add(params[:id], session_cache_key)
    render :nothing => true
  end

  def next_track
    id = Queue.remove(session_cache_key)
    render :json => {'id' => (id ? id : '')}, :layout => false
  end

  def queue_has_tracks
    render :json => {'has_tracks' => (Queue.list(session_cache_key).empty? ? 'false' : 'true')}, :layout => false
  end

end

