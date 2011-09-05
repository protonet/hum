require 'dm-rails/middleware/identity_map'
class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  def rails_path
    render :text => send("#{params[:path_name]}_path"), :layout => false
  end

  def server_url
    hum_config = HumConfig.conf
    hum_config.server = params[:server_url]
    hum_config.save
    expire_page :action => 'index'
    render :text => hum_config.server, :layout => false
  end

protected

  def session_cache_key
    request.session_options[:id]
  end

end

