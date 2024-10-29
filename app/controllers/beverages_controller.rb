class BeveragesController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :check_user_restaurant

  def index
    @beverages = current_user.restaurant.beverages
  end

  def show
    @beverage = Beverage.find_by(id: params[:id])

    if @beverage.nil? || @beverage.restaurant != current_user.restaurant
      redirect_to beverages_path
    end
  end

  def new
    @beverage = Beverage.new
  end

  def create
    @beverage = Beverage.new(beverage_params)
    @beverage.restaurant = current_user.restaurant
    if @beverage.save
      flash[:notice] = 'Bebida cadastrada com sucesso'
      redirect_to beverages_path
    else
      @beverage.valid?
      flash[:alert] = 'Erro ao cadastrar bebida'

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @beverage = Beverage.find_by(id: params[:id])

    if @beverage.nil? || @beverage.restaurant != current_user.restaurant
      redirect_to beverages_path
    end
  end

  def update
    @beverage = Beverage.find_by(id: params[:id])

    if @beverage.nil? || @beverage.restaurant != current_user.restaurant
      return
    end

    if @beverage.update(beverage_params)
      flash[:notice] = 'Bebida atualizada com sucesso'
      redirect_to beverages_path
    else
      @beverage.valid?
      flash[:alert] = 'Erro ao atualizar bebida'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @beverage = Beverage.find_by(id: params[:id])
    return unless @beverage.restaurant == current_user.restaurant

    @beverage.destroy
    redirect_to beverages_path
  end

  private

  def beverage_params
    params.require(:beverage).permit(:name, :description, :alcoholic, :calories, :image)
  end

  def check_user_restaurant
    redirect_to new_restaurant_path unless current_user.restaurant
  end
end