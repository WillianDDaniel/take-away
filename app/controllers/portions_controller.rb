class PortionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_restaurant

  def new
    @dish = Dish.find_by(id: params[:dish_id])
    @beverage = Beverage.find_by(id: params[:beverage_id])

    @menu_item = @beverage || @dish

    if @menu_item.nil? || @menu_item.restaurant != current_user.restaurant
      redirect_to dashboard_path
    else
      @portion = Portion.new
    end
  end

  def create
    @dish = Dish.find_by(id: params[:dish_id])
    @beverage = Beverage.find_by(id: params[:beverage_id])

    @menu_item = @beverage || @dish

    if @menu_item.nil? || @menu_item.restaurant != current_user.restaurant
      return
    end

    price = params[:portion][:price].to_i
    description = params[:portion][:description]

    @portion =  Portion.new(portionable: @menu_item, price: price, description: description)

    if @portion.save
      flash[:notice] = 'Porção cadastrada com sucesso'
      redirect_to @menu_item
    else
      @portion.valid?
      render :new, status: :unprocessable_entity
    end
  end

  private

  def portion_params
    params.require(:portion).permit(:description, :price)
  end

  def check_user_restaurant
    redirect_to new_restaurant_path unless current_user.restaurant
  end
end