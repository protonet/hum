Hum::Application.routes.draw do
  root :to => 'application#index'

  match 'reload_tracks'    => 'application#reload_tracks', :as => 'reload_tracks'
end
