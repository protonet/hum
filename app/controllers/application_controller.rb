require 'dm-rails/middleware/identity_map'
class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  def index
    Track.load_tracks unless Track.tracks_loaded?
    @tracks = Track.tracks
  end

  def reload_tracks
    Track.load_tracks
    redirect_to :action => 'index'
  end

  def fetch_tracks
    Track.fetch_tracks
    Track.load_tracks
    redirect_to :action => 'index'
  end

  def server_url
    hum_config = HumConfig.conf
    hum_config.server = params[:server_url]
    hum_config.save
    expire_page :action => 'index'
    render :text => hum_config.server, :layout => false
  end

  def track
    tracks = Track.tracks
    track = tracks[params[:id].to_i]

    respond_to do |format|
      format.js do
        puts "TRACK IS #{track.to_json}"
        render :text => track.to_json, :layout => false
      end
    end
  end
end
