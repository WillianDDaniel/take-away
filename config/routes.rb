Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  get "/dashboard", to: "dashboard#index"
  get "/search", to: "search#index"

  resources :restaurants, only: [:new, :create, :show]
  resources :schedules, only: [:new, :create, :index, :edit, :update, :destroy]
  resources :tags, only: [:new, :create, :index, :edit, :update, :destroy]
  resources :orders, only: [:new, :create, :index, :show]
  resources :employees, only: [:new, :create, :index]

  resources :menus do
    member do
      get :manage_menu, as: :manage
      post :update_menu_items, as: :update_items
    end
  end

  resources :dishes do
    member do
      patch :toggle_status
    end
    resources :portions, only: [:new, :create, :index, :edit, :update, :destroy]
  end

  resources :beverages do
    member do
      patch :toggle_status
    end
    resources :portions, only: [:new, :create, :index, :edit, :update, :destroy]
  end

  namespace :api do
    namespace :v1 do
      resources :restaurants, param: :code, only: [:show] do
        resources :orders, param: :code, only: [:index, :show, :update]
      end
    end
  end
end
