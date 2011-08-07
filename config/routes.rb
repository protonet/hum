Hum::Application.routes.draw do
  root :to => 'application#index'

  match 'load_tracks'    => 'application#load_tracks', :as => 'load_tracks'
end
