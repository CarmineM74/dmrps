Dmrps::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :sessions do
        get 'authenticated_user', on: :collection
      end
      resources :users
      resources :clients
      resources :locations
      resources :interventions do
        get 'by_client/:client_id', on: :collection, action: 'by_client'
        get 'by_user/:user_id', on: :collection, action: 'by_user'
        get 'rps', :to => 'interventions#rps'
      end
    end
  end

  root :to => 'main#index'
end
