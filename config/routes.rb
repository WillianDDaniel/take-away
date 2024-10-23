Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  get "/dashboard", to: "dashboard#index"

  resources :restaurants, only: [:new, :create]
end
