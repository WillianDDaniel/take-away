class PortionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_restaurant

  def new
    @dish = Dish.find_by(id: params[:dish_id])

    if @dish.nil? || @dish.restaurant != current_user.restaurant
      redirect_to dashboard_path
    else
      @portion = Portion.new
    end

  end

  private

  def check_user_restaurant
    redirect_to new_restaurant_path unless current_user.restaurant
  end
end