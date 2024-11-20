class PortionsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :authorize_owners!

  def new
    @dish = Dish.find_by(id: params[:dish_id])
    @beverage = Beverage.find_by(id: params[:beverage_id])

    @portionable = @beverage || @dish

    if @portionable.nil? || @portionable.restaurant != current_user.restaurant
      redirect_to dashboard_path
    else
      @portion = Portion.new
    end
  end

  def create
    @dish = Dish.find_by(id: params[:dish_id])
    @beverage = Beverage.find_by(id: params[:beverage_id])

    @portionable = @beverage || @dish

    if @portionable.nil? || @portionable.restaurant != current_user.restaurant
      return
    end

    price = params[:portion][:price].to_i
    description = params[:portion][:description]

    @portion =  Portion.new(portionable: @portionable, price: price, description: description)

    if @portion.save
      flash[:notice] = 'Porção cadastrada com sucesso'
      redirect_to @portionable
    else
      @portion.valid?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @portion = Portion.find_by(id: params[:id])
    @portionable = @portion.portionable if @portion

    if @portion.nil? || @portion.portionable.restaurant != current_user.restaurant
      redirect_to dashboard_path
    end
  end

  def update
    @portion = Portion.find_by(id: params[:id])
    @portionable = @portion.portionable if @portion

    if @portion.nil? || @portion.portionable.restaurant != current_user.restaurant
      redirect_to dashboard_path
    end

    if @portion.update(portion_params)
      flash[:notice] = 'Porção atualizada com sucesso'
      redirect_to @portionable
    else
      @portion.valid?
      flash[:alert] = 'Erro ao atualizar porção.'

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @portion = Portion.find_by(id: params[:id])
    @portionable = @portion.portionable if @portion

    if @portion.nil? || @portion.portionable.restaurant != current_user.restaurant
      redirect_to dashboard_path
    end

    @portion.discard
    flash[:notice] = 'Porção excluída com sucesso.'
    redirect_to @portionable
  end

  private

  def portion_params
    params.require(:portion).permit(:description, :price)
  end
end