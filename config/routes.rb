Rails.application.routes.draw do
  get '/', to: 'home#index'
  namespace :synchronizers do
    resources :products_synchronizer
  end
end
