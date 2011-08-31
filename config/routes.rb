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

  match '/track/id/:id' => 'tracks#id'

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

