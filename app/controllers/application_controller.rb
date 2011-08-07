require 'dm-rails/middleware/identity_map'
class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  def index

  end

  def load_tracks
    load
    render :action => 'index'
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
