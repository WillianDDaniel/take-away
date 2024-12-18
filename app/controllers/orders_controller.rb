class OrdersController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :check_user_restaurant

  def index
    @orders = current_user.current_restaurant.orders.order(created_at: :desc)
  end

  def show
    @order = Order.find_by(id: params[:id])

    @order_items = @order.order_items
    @menu = @order.menu

    @total_price = @order_items.sum { |item| item.portion.price * item.quantity }
  end

  def new
    @menu = Menu.find_by(id: params[:menu_id])

    if @menu.nil? || @menu.restaurant != current_user.current_restaurant
      redirect_to dashboard_path
    end
    @order = Order.new(menu_id: params[:menu_id])
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      flash[:notice] = 'Pedido cadastrado com sucesso!'

      redirect_to @order
    else
      @order.valid?
      flash.now[:alert] = 'Erro ao cadastrar pedido'

      render :new, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :menu_id, :customer_phone, :customer_email, :customer_doc,
      order_items_attributes: [:portion_id, :quantity, :note]
    )
  end

  def check_user_restaurant
    redirect_to new_restaurant_path unless current_user.current_restaurant
  end
end
