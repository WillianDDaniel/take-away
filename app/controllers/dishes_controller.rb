class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_have_restaurant?

  def new
    @dish = Dish.new
  end

  def create
    @dish = Dish.new(dish_params)
    @dish.restaurant = current_user.restaurant
    if @dish.save
      flash[:notice] = 'Prato cadastrado com sucesso'
      redirect_to dashboard_path
    else
      @dish.valid?

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @dish = Dish.find_by(id: params[:id])

    if @dish.nil? || @dish.restaurant != current_user.restaurant
      redirect_to dashboard_path
    end
  end

  def update
    @dish = Dish.find(params[:id])

    if @dish.update(dish_params)
      flash[:notice] = 'Prato atualizado com sucesso'
      redirect_to dashboard_path
    else
      @dish.valid?
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def dish_params
    params.require(:dish).permit(:name, :description, :price, :calories)
  end

  def user_have_restaurant?
    redirect_to new_restaurant_path unless current_user.restaurant
  end
end