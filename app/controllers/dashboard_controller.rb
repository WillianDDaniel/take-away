class DashboardController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def index
    @user = current_user

    @menus = Menu.where(restaurant: @user.restaurant)
  end
end
