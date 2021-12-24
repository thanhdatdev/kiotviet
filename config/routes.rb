Rails.application.routes.draw do
  devise_for :users, except: %w[sessions#new session#create]
  root to: 'home#index'
  namespace :synchronizers do
    resources :products_synchronizer, only: %i[index]
    resources :orders_synchronizer, only: %i[index]
    resources :users_synchronizer, only: %i[index]
  end

  get '/oauth2/callback', to: 'oauth#oauth_callback'
  get '/logout', to: 'oauth#logout'
  get '/login', to: 'oauth#login'

  namespace :customers do
    resources :sessions
  end
end
