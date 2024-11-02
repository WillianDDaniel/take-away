class TagsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :check_user_restaurant

  def index
    @tags = Tag.where(restaurant: current_user.restaurant)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.restaurant = current_user.restaurant
    if @tag.save
      flash[:notice] = 'Marcador cadastrado com sucesso'
      redirect_to tags_path
    else
      @tag.valid?
      render :new
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def check_user_restaurant
    redirect_to new_restaurant_path unless current_user.restaurant
  end
end