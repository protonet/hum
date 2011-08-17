Hum::Application.routes.draw do
  root :to => 'application#index'

  match 'reload_tracks' => 'application#reload_tracks', :as => 'reload_tracks'
  match 'reload_assets' => 'application#reload_assets', :as => 'reload_assets'
  match 'tracks'        => 'application#tracks',        :as => 'tracks'
  match 'server_url'    => 'application#server_url',    :as => 'server_url'
end

