require 'dm-rails/middleware/identity_map'
class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  def index
    @number_of_tracks = Track.count
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
