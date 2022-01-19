Rails.application.routes.draw do
  devise_for :users, except: %w[sessions#new sessions#create sessions#destroy], controllers: {sessions: "sessions"}
  mount Sidekiq::Web => '/sidekiq'
  root to: 'home#index'
  namespace :synchronizers do
    resources :products_synchronizer, only: %i[index]
    resources :orders_synchronizer, only: %i[index]
    resources :users_synchronizer, only: %i[index]
  end

  namespace :webhooks do
    get '/invoices', to: 'invoices#index'
  end

  namespace :customers do
    resources :sessions
  end
end
