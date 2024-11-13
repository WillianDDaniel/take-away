class Api::V1::OrdersController < ActionController::API
  before_action :find_restaurant, only: [:index, :show]

  def index
    status = params[:status]

    if status.present? && Order.statuses.key?(status)
      render json: @restaurant.orders.where(status: status), status: :ok
    else
      render json: @restaurant.orders.all, status: :ok
    end
  end

  def show
    order = @restaurant.orders.find_by(code: params[:code])

    unless order
      render json: {
        error: 'Código de pedido inválido ou inexistente',
        message: 'Verifique o código do pedido e tente novamente'
      }, status: :not_found

      return
    end

    response = {
      code: order.code,
      customer_name: order.customer_name,
      order_date: order.created_at.strftime('%d/%m/%Y %H:%M:%S'),
      status: order.status,
      items: parse_order_items(order.order_items)
    }

    render json: response, status: :ok
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

  def parse_order_items(order_items)
    order_items.map do |order_item|
      {
        name: order_item.portion.portionable.name,
        description: order_item.portion.description,
        quantity: order_item.quantity,
        note: order_item.note
      }
    end
  end
end