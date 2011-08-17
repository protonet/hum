require 'dm-rails/middleware/identity_map'
class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  caches_page :index

  def index
    load_tracks
  end

  def reload_assets
    expire_page :action => 'index'
    redirect_to :action => 'index'
  end

  def reload_tracks
    fetch_tracks
    expire_page :action => 'index'
    redirect_to :action => 'index'
  end

  def server_url
    hum_config = HumConfig.conf
    hum_config.server = params[:server_url]
    hum_config.save
    expire_page :action => 'index'
    render :text => hum_config.server, :layout => false
  end

protected

  def load_tracks
    logger.info "Fetching tracks #{Time.now}"
    fetch_tracks unless File.exist?(tracks_file)
    logger.info "loading json #{Time.now}"
    json_contents = ""

    File.open(tracks_file, 'r') do |file|
      json_contents = file.read
    end
    logger.info "parsing json #{Time.now}"

    @listing = JSON.parse(json_contents)
  end

  def fetch_tracks
    File.open(tracks_file, 'w') do |file|
      parsed_json = JSON.parse(HumConfig.get_listing)
      file.write(parsed_json.to_json)
    end
  end

private

  def tracks_file
    @tracks_file ||= "#{Rails.root}/tmp/tracks.json"
  end

end

