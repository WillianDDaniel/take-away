class DashboardController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :user_have_restaurant?

  def index
    @user = current_user

    @menus = Menu.where(restaurant: @user.restaurant)
  end

  private

  def user_have_restaurant?
    redirect_to new_restaurant_path unless current_user.restaurant
  end
end
