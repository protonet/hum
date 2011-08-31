class ListController < ApplicationController

  def index
    render :json => List.list, :layout => false
  end

  def add_track
    List.add(params[:id])
  end

end

