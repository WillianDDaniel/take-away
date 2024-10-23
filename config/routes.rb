Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  get "/dashboard", to: "dashboard#index"
end
