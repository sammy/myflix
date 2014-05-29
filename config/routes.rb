Myflix::Application.routes.draw do

  
  default_url_options host: Rails.application.config.domain
  
  mount StripeEvent::Engine => '/stripe_events'

  get 'ui(/:action)', controller: 'ui'

  root to: "pages#front"

  resources :videos,            only: [:show] do
    collection do
      post :search
    end
    resources :reviews,         only: [:create]
  end

  resources :categories,        only: [:show]
  resources :queue_items,       only: [:create, :destroy]
  resources :users,             only: [:create, :show]
  resources :sessions,          only: [:create]
  resources :relationships,     only: [:destroy, :create]
  resources :forgot_passwords,  only: [:create]
  resources :invitations,       only: [:new,:create]

  namespace :admin do
    resources :videos,          only: [:new, :create]
    resources :payments,        only: [:index]
  end

  get 'home',                     to: "videos#home"

  get 'register',                 to: "users#new"
  get 'register/:token',          to: "users#register_with_token",        as: :register_with_token  

  get 'sign_in',                  to: "sessions#new"
  get 'sign_out',                 to: "sessions#destroy"

  get 'my_queue',                 to: "queue_items#index"
  post 'queue_items_reorder',     to: "queue_items#reorder"

  get 'people',                   to: "relationships#index"

  get 'forgot_password',          to: "forgot_passwords#new"
  get 'confirm_password_reset',   to: "forgot_passwords#index"
  get 'password_reset(/:token)',  to: "forgot_passwords#edit",            as: :password_reset  
  post 'update_password',         to: "forgot_passwords#update"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq' 


end