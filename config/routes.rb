Hum::Application.routes.draw do
  root :to => 'application#index'

  match 'load_tracks'    => 'application#load_tracks', :as => 'load_tracks'
  match 'play_track/:id' => 'application#play_track',  :as => 'play_track'

end
