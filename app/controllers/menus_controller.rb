class MenusController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :authorize_owners!, only: [:new, :create, :edit, :update, :destroy, :manage_menu, :update_menu_items]

  def index
    @menus = Menu.where(restaurant: current_user.current_restaurant, discarded_at: nil)

    unless current_user.current_restaurant
      redirect_to new_restaurant_path
    end
  end

  def show
    @menu = Menu.find_by(id: params[:id])

    if @menu.nil? || @menu.restaurant != current_user.current_restaurant
      return redirect_to dashboard_path
    end

    if @menu.discarded?
      redirect_to menus_path
    end
  end

  def new
    @menu = Menu.new
  end

  def create
    @menu = Menu.new(menu_params)
    @menu.restaurant = current_user.restaurant

    if @menu.save
      flash[:notice] = 'Cardápio criado com sucesso'
      redirect_to manage_menu_path(@menu)
    else
      @menu.valid?
      flash.now[:alert] = 'Erro ao cadastrar cardápio'

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @menu = Menu.find_by(id: params[:id])

    if @menu.nil? || @menu.restaurant != current_user.restaurant
      redirect_to dashboard_path
    end
  end

  def update
    @menu = Menu.find_by(id: params[:id])
    return unless @menu.restaurant == current_user.restaurant

    if @menu.update(menu_params)
      flash[:notice] = 'Cardápio atualizado com sucesso'
      redirect_to menus_path
    else
      @menu.valid?
      flash[:alert] = 'Erro ao atualizar cardápio'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu = Menu.find_by(id: params[:id])
    return unless @menu.restaurant == current_user.restaurant

    if @menu.discard
      @menu.menu_items.destroy_all
      flash[:notice] = 'Cardápio excluído com sucesso'
      redirect_to menus_path
    else
      flash[:alert] = 'Erro ao excluir cardápio'
      redirect_to menus_path
    end
  end

  def manage_menu
    @menu = Menu.find_by(id: params[:id])

    if @menu.nil? || @menu.restaurant != current_user.restaurant
      return redirect_to dashboard_path
    end

    if @menu.discarded?
      redirect_to menus_path
    end

    @dishes = current_user.restaurant.dishes
    @beverages = current_user.restaurant.beverages

    @selected_dish_ids = @menu.menu_items.where(menuable_type: 'Dish').pluck(:menuable_id)
    @selected_beverage_ids = @menu.menu_items.where(menuable_type: 'Beverage').pluck(:menuable_id)
  end

  def update_menu_items
    @menu = Menu.find_by(id: params[:id])

    if @menu.nil? || @menu.restaurant != current_user.restaurant
      redirect_to dashboard_path
    end

    @menu.menu_items.destroy_all

    if params[:dish_ids].present?
      params[:dish_ids].each do |dish_id|
        @menu.menu_items.create(menuable_type: 'Dish', menuable_id: dish_id)
      end
    end

    if params[:beverage_ids].present?
      params[:beverage_ids].each do |beverage_id|
        @menu.menu_items.create(menuable_type: 'Beverage', menuable_id: beverage_id)
      end
    end

    flash[:notice] = 'Itens do cardápio atualizados com sucesso!'
    redirect_to menus_path
  end

  private

  def menu_params
    params.require(:menu).permit(:name, menu_items_attributes: [:id, :menuable_id])
  end
end