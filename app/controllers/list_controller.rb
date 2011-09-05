class ListController < ApplicationController

  def index
    @list = List.list(session_cache_key)
    render :layout => false
  end

  def add_to
    List.add(params[:id], session_cache_key)
    render :nothing => true
  end

  def clear_tracks
    List.clear(session_cache_key)
  end

end

