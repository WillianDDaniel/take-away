class Api::V1::OrdersController < ActionController::API
  before_action :find_restaurant, only: :index

  def index
    status = params[:status]

    if status.present? && Order.statuses.key?(status)
      render json: @restaurant.orders.where(status: status)
    else
      render json: @restaurant.orders.all
    end
  end

  private

  def order_params
    params.require(:order).permit(:status, :restaurant_code)
  end

  def find_restaurant
    @restaurant = Restaurant.find_by(code: params[:restaurant_code])

    unless @restaurant
      render json: {
        error: 'Restaurante não encontrado',
        message: 'Verifique o código do restaurante e tente novamente'
      }, status: :not_found

      return
    end
  end
end