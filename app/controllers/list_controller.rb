class ListController < ApplicationController

  def index
    @list = List.list
    render :layout => false
  end

  def add_to
    List.add(params[:id])
    render :nothing => true
  end

  def clear_tracks
    List.clear
  end

end

