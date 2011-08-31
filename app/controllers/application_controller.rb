require 'dm-rails/middleware/identity_map'
class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  def rails_path
    render :text => send("#{params[:path_name]}_path"), :layout => false
  end

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

  def track_hash
    render :json => {'md5_hash' => Track.tracks[params[:index].to_i].md5_hash}, :layout => false
  end

  def track
    tracks = Track.tracks
    track = tracks[params[:id].to_i]

    respond_to do |format|
      format.js do
        render :text => track.to_json, :layout => false
      end
    end
  end

  def search
    tracks = Track.search(params['term'])
    render :partial => 'tracks', :locals => {:tracks => tracks}
  end
end
