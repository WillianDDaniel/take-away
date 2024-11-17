class Api::V1::OrdersController < ActionController::API
  before_action :find_restaurant, only: [:index, :show, :update]

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
      created_at: order.created_at,
      status: order.status,
      items: parse_order_items(order.order_items),
    }

    render json: response, status: :ok
  end

  def update
    order = @restaurant.orders.find_by(code: params[:code])

    unless order
      render json: {
        error: 'Código de pedido inválido ou inexistente',
        message: 'Verifique o código do pedido e tente novamente'
      }, status: :not_found

      return
    end

    unless order.pending? || order.preparing?
      render json: {
        error: 'Pedido não pode ser alterado',
        message: 'Alteração de pedido não autorizada'
      }, status: :forbidden

      return
    end

    if order.pending?
      order.update(status: :preparing)

    elsif order.preparing?
      order.update(status: :ready)
    end

    render json: order, status: :ok
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
        price: order_item.portion.price,
        quantity: order_item.quantity,
        note: order_item.note
      }
    end
  end
end