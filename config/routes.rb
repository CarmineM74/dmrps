Dmrps::Application.routes.draw do
  resources :users
  root :to => 'main#index'
end
