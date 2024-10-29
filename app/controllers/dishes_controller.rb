class DishesController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :user_have_restaurant?

  def index
    @dishes = current_user.restaurant.dishes
  end

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

  def show
    @dish = Dish.find_by(id: params[:id])

    if @dish.nil? || @dish.restaurant != current_user.restaurant
      redirect_to dashboard_path
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

  def destroy
    @dish = Dish.find_by(id: params[:id])
    return unless @dish.restaurant == current_user.restaurant

    if @dish.destroy
      flash[:notice] = 'Prato excluído com sucesso'
    else
      flash[:alert] = 'Erro ao excluir prato'
    end

    redirect_to dashboard_path
  end

  def toggle_status
    @dish = Dish.find(params[:id])

    if @dish.active?
      @dish.update(status: "paused")
    else
      @dish.update(status: "active")
    end

    redirect_to dish_path(@dish), notice: "Status atualizado com sucesso."
  end

  private

  def dish_params
    params.require(:dish).permit(:name, :description, :calories, :image)
  end

  def user_have_restaurant?
    redirect_to new_restaurant_path unless current_user.restaurant
  end
end