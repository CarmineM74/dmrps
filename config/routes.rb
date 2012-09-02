Dmrps::Application.routes.draw do
  resources :sessions
  resources :users
  root :to => 'main#index'
end
