Dmrps::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :sessions
      resources :users
      resources :clients
      resources :locations
      resources :interventions do
        get 'by_client/:client_id', on: :collection, action: 'by_client'
        get 'by_user/:user_id', on: :collection, action: 'by_user'
      end
    end
  end

  get 'test_pdf', :to => 'main#test_pdf'

  root :to => 'main#index'
end
