Hum::Application.routes.draw do

  root :to => 'tracks#index'


  match 'server_url' => 'application#server_url',    :as => 'server_url'

  resources :tracks, :only => [:index, :show] do
    collection do
      get 'fetch'
      get 'reload'
      get 'search'
    end
  end

  match '/track/to_id/:index'    => 'tracks#to_id'
  match '/track/to_index/:id'    => 'tracks#to_index'

  match '/queue'                     => 'queue#index',       :as => 'queue'
  match '/queue/add_to/:id'          => 'queue#add_to',      :as => 'add_to_queue'
  match '/queue/remove_from/:index ' => 'queue#remove_from', :as => 'remove_from_queue'
  match '/queue/next_track'          => 'queue#next_track',  :as => 'next_track'

  match '/list'                  => 'list#index',        :as => 'list'
  match '/list/add_to/:id'       => 'list#add_to',       :as => 'add_to_list'

end

