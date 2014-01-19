Myflix::Application.routes.draw do
  
  get 'ui(/:action)', controller: 'ui'

  root to: "pages#front"
  get 'home', to: "videos#home"


  resources :videos, only: [:show] do
    collection do
      post :search
    end
  end

  resources :categories, only: [:show]

  get 'register', to: "users#new"
  get 'sign_in', to: "sessions#new"
  get 'sign_out', to: "sessions#destroy"

  resources :users, only: [:create]
  resources :sessions, only: [:create]

end
