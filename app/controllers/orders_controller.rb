class OrdersController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :check_user_restaurant

  def new
    @order = Order.new
    @menu = Menu.find_by(id: params[:menu_id])
  end

  def create
    @menu = Menu.find_by(id: params[:menu_id])
    @order = Order.new(order_params)

    if @order.save
      redirect_to @order, notice: 'Pedido criado com sucesso!'
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :contact_phone, :contact_email, :cpf,
      order_items_attributes: [:portion_id, :quantity, :note]
    )
  end

  def check_user_restaurant
    redirect_to new_restaurant_path unless current_user.restaurant
  end
end
