class MenusController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :check_user_restaurant

  def index
    @menus = Menu.where(restaurant: current_user.restaurant)
  end

  def new
    @menu = Menu.new
  end

  def create
    @menu = Menu.new(menu_params)
    @menu.restaurant = current_user.restaurant

    if @menu.save
      flash[:notice] = 'Cardápio criado com sucesso'
      redirect_to menus_path
    else
      @menu.valid?
      flash[:alert] = 'Erro ao cadastrar cardápio'

      render :new
    end
  end

  private

  def menu_params
    params.require(:menu).permit(:name)
  end

  def check_user_restaurant
    redirect_to new_restaurant_path if current_user.restaurant.nil?
  end
end