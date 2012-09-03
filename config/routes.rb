Dmrps::Application.routes.draw do
  resources :sessions
  resources :users
  resources :clients
  root :to => 'main#index'
end
