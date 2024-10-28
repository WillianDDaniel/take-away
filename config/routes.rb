Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  get "/dashboard", to: "dashboard#index"

  resources :restaurants, only: [:new, :create]
  resources :schedules, only: [:new, :create, :index, :edit, :update, :destroy]

  resources :dishes
  resources :beverages

  get "/search", to: "search#index"
end
