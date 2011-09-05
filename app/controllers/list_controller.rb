class ListController < ApplicationController

  def index
    @list = List.list(session_id)
    render :layout => false
  end

  def add_to
    List.add(params[:id], session_id)
    render :nothing => true
  end

  def clear_tracks
    List.clear(session_id)
  end

end

