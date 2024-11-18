class RestaurantsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :check_user_restaurant, only: [:show]

  def show
    @restaurant = current_user.current_restaurant
  end

  def new
    redirect_to dashboard_path if current_user.current_restaurant
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user_id = current_user.id
    if @restaurant.save
      flash[:notice] = 'Restaurante cadastrado com sucesso'
      redirect_to dashboard_path
    else
      @restaurant.valid?
      render :new, status: :unprocessable_entity
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(
      :brand_name, :corporate_name, :email,
      :doc_number, :phone, :address
    )
  end

  def check_user_restaurant
    redirect_to new_restaurant_path unless current_user.current_restaurant
  end
end