Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  get "/dashboard", to: "dashboard#index"
  get "/search", to: "search#index"

  resources :restaurants, only: [:new, :create]
  resources :schedules, only: [:new, :create, :index, :edit, :update, :destroy]
  resources :tags, only: [:new, :create, :index, :edit, :update, :destroy]

  resources :menus do
    member do
      get :manage_menu, as: :manage
      post :update_menu_items, as: :update_items
    end
    resources :orders, only: [:new, :create, :index, :show]
  end

  resources :dishes do
    member do
      patch :toggle_status
    end
    resources :portions, only: [:new, :create, :index, :edit, :update]
  end

  resources :beverages do
    member do
      patch :toggle_status
    end
    resources :portions, only: [:new, :create, :index, :edit, :update, :destroy]
  end

end
