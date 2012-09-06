Dmrps::Application.routes.draw do
  resources :sessions
  resources :users
  resources :clients
  resources :locations
  root :to => 'main#index'
end
