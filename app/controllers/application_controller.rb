require 'dm-rails/middleware/identity_map'
class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  def index
    load
  end

  def reload_tracks
    reload
    redirect_to :action => 'index'
  end

protected

  def load
    if session[:listing]
      @listing = session[:listing]
    else
      @listing = session[:listing] = JSON.parse(HumConfig.get_listing)
    end
  end

  def reload
    @listing = session[:listing] = JSON.parse(HumConfig.get_listing)
  end

end
