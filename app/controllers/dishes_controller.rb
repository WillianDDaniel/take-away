class DishesController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :authorize_owners!
  before_action :check_dish_owner, only: [:show, :edit, :update, :destroy, :toggle_status]

  def index
    @dishes = current_user.restaurant.dishes
  end

  def show ;  end

  def new
    @dish = Dish.new
    @dish.tags.build
    @tags = Tag.where(restaurant: current_user.restaurant)
  end

  def create
    @dish = Dish.new(dish_params)
    @dish.restaurant = current_user.restaurant

    if @dish.save
      flash[:notice] = 'Prato cadastrado com sucesso'
      redirect_to dishes_path
    else
      @dish.valid?
      @tags = Tag.where(restaurant: current_user.restaurant)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tags = Tag.where(restaurant: current_user.restaurant)
  end

  def update
    if @dish.update(dish_params)
      flash[:notice] = 'Prato atualizado com sucesso'
      redirect_to dishes_path
    else
      @dish.valid?
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @dish.destroy
      flash[:notice] = 'Prato excluído com sucesso'
    else
      flash[:alert] = 'Erro ao excluir prato'
    end
    redirect_to dishes_path
  end

  def toggle_status
    if @dish.active?
      @dish.update(status: "paused")
    else
      @dish.update(status: "active")
    end

    redirect_to dish_path(@dish), notice: "Status atualizado com sucesso."
  end

  private

  def dish_params
    params.require(:dish).permit(:name, :description, :calories,
      :image, tags_attributes: [:id, :name, :_destroy],
      tag_ids: []
    )
  end

  def check_dish_owner
    @dish = Dish.find_by(id: params[:id])

    if @dish.nil? || @dish.restaurant != current_user.restaurant
      redirect_to dishes_path
    end
  end
end