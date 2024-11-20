class DashboardController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :check_user_restaurant

  def index
    @user = current_user

    @menus = Menu.where(restaurant: @user.current_restaurant, discarded_at: nil)
  end

  private

  def check_user_restaurant
    redirect_to new_restaurant_path unless current_user.current_restaurant
  end
end
