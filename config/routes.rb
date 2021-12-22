Rails.application.routes.draw do
  get '/', to: 'home#index'
  namespace :synchronizers do
    resources :products_synchronizer, only: %i[index]
    resources :order_synchronizer, only: %i[index]
  end

  resources :kiotviet_oauth2
end
