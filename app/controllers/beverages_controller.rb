class BeveragesController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :authorize_owners!
  before_action :check_beverage_owner, only: [:show, :edit, :update, :destroy, :toggle_status]

  def index
    @beverages = current_user.restaurant.beverages.where(discarded_at: nil)
  end

  def show
    if @beverage.discarded?
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
      redirect_to @beverage
    else
      @beverage.valid?
      flash[:alert] = 'Erro ao cadastrar bebida'

      render :new, status: :unprocessable_entity
    end
  end

  def edit ;  end

  def update
    if @beverage.update(beverage_params)
      flash[:notice] = 'Bebida atualizada com sucesso'
      redirect_to @beverage
    else
      @beverage.valid?
      flash[:alert] = 'Erro ao atualizar bebida'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
     if @beverage.discard
       flash[:notice] = 'Bebida excluida com sucesso'
     else
       flash[:alert] = 'Erro ao excluir bebida'
     end
    redirect_to beverages_path
  end

  def toggle_status
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

  def check_beverage_owner
    @beverage = Beverage.find_by(id: params[:id])

    if @beverage.nil? || @beverage.restaurant != current_user.restaurant
      redirect_to beverages_path
    end
  end
end