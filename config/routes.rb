Hum::Application.routes.draw do

  root :to => 'application#index'

  match 'fetch_tracks' => 'application#fetch_tracks', :as => 'fetch_tracks'
  match 'load_tracks ' => 'application#load_tracks',  :as => 'load_tracks'
  match 'server_url'   => 'application#server_url',   :as => 'server_url'
  match 'search/:term' => 'application#search',       :as => 'search'
  match 'show/:id'     => 'application#show',         :as => 'show'

end