Dmrps::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :sessions
      resources :users
      resources :clients
      resources :locations
    end
  end

  root :to => 'main#index'
end
