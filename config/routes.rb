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

  match '/track/to_id/:index' => 'tracks#to_id'
  match '/track/to_index/:id' => 'tracks#to_index'

  resources :queue, :only => [:index] do
    collection do
      get 'add_to'
      get 'remove_from'
    end
  end

  resources :list, :only => [:index] do
    collection do
      get 'add_to'
    end
  end

end

