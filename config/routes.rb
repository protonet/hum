Hum::Application.routes.draw do

  root :to => 'application#index'

  match 'fetch_tracks'      => 'application#fetch_tracks',  :as => 'fetch_tracks'
  match 'reload_tracks '    => 'application#reload_tracks', :as => 'reload_tracks'
  match 'server_url'        => 'application#server_url',    :as => 'server_url'
  match 'search/:term'      => 'application#search',        :as => 'search'
  match 'track/:id'         => 'application#track',         :as => 'track'
  match 'track_hash/:index' => 'application#track_hash',    :as => 'track_hash'

end