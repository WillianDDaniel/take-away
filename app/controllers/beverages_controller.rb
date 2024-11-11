class BeveragesController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :authorize_owners!

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

  def toggle_status
    @beverage = Beverage.find(params[:id])

    if @beverage.active?
      @beverage.update(status: "paused")
    else
      @beverage.update(status: "active")
    end

    redirect_to beverage_path(@beverage), notice: "Status atualizado com sucesso."
  end

  private

  def beverage_params
    params.require(:beverage).permit(:name, :description, :alcoholic, :calories, :image)
  end
end