require 'dm-rails/middleware/identity_map'
class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  def index

  end

  def load_tracks
    @listing = JSON.parse(HumConfig.get_listing)[0,10]
    render :action => 'index'
  end

  def play_tack

  end
end
