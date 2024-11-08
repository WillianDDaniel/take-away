class OrdersController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :check_user_restaurant

  def show
    @order = Order.find_by(id: params[:id])

    @order_items = @order.order_items
    @menu = Menu.find_by(id: params[:menu_id])

    @total_price = @order_items.sum { |item| item.portion.price * item.quantity }
  end

  def new
    @order = Order.new
    @menu = Menu.find_by(id: params[:menu_id])
  end

  def create
    @menu = Menu.find_by(id: params[:menu_id])
    @order = Order.new(order_params)

    if @order.save
      flash[:notice] = 'Pedido cadastrado com sucesso!'
      redirect_to menu_order_path(@menu, @order)
    else
      @order.valid?
      flash.now[:alert] = 'Erro ao cadastrar pedido'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :customer_phone, :customer_email, :customer_doc,
      order_items_attributes: [:portion_id, :quantity, :note]
    )
  end

  def check_user_restaurant
    redirect_to new_restaurant_path unless current_user.restaurant
  end
end
