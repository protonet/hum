class TracksController < ApplicationController

  def index
    Track.load_tracks unless Track.tracks_loaded?
    @tracks = Track.tracks
  end

  def show
    tracks = Track.tracks
    track = tracks[Track.hash_to_index(params[:id])]
    render :json => track, :layout => false
  end

  def reload
    Track.load_tracks
    redirect_to :action => 'index'
  end

  def fetch
    Track.fetch_tracks
    Track.load_tracks
    redirect_to :action => 'index'
  end

  def to_id
    render :json => {'id' => Track.tracks[params[:index].to_i].id}, :layout => false
  end

  def to_index
    render :json => {'index' => Track.tracks.index(params[:id])}, :layout => false
  end

  def search
    tracks = Track.search(params['term'])
    render :partial => 'tracks', :locals => {:tracks => tracks}
  end
end

