Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  get "/dashboard", to: "dashboard#index"
  get "/search", to: "search#index"

  resources :restaurants, only: [:new, :create]
  resources :schedules, only: [:new, :create, :index, :edit, :update, :destroy]

  resources :dishes do
    member do
      patch :toggle_status
    end
    resources :portions, only: [:new, :create, :index]
  end


  resources :beverages do
    member do
      patch :toggle_status
    end
    resources :portions, only: [:new, :create, :index, :edit, :update]
  end

end
