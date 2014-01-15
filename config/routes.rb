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
  resources :users, only: [:create]

end
