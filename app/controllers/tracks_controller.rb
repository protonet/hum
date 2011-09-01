class TracksController < ApplicationController

  def index
    Track.load_tracks unless Track.tracks_loaded?
    @tracks = Track.tracks
  end

  def show
    tracks = Track.tracks
    track = tracks[Track.hash_to_index(params[:id])]

    respond_to do |format|
      format.js do
        render :text => track.to_json, :layout => false
      end
    end
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
    render :json => {'id' => Track.tracks[params[:index].to_i].md5_hash}, :layout => false
  end

  def to_index
    render :json => {'index' => Track.tracks.index(params[:id])}, :layout => false
  end

  def search
    tracks = Track.search(params['term'])
    render :partial => 'tracks', :locals => {:tracks => tracks}
  end
end

