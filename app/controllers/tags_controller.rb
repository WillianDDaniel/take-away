class TagsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :authorize_owners!

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
      flash.now[:alert] = 'Erro ao cadastrar marcador'

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tag = Tag.find_by(id: params[:id])

    if @tag.nil? || @tag.restaurant != current_user.restaurant
      redirect_to tags_path
    end
  end

  def update
    @tag = Tag.find_by(id: params[:id])
    if @tag.update(tag_params)
      flash[:notice] = 'Marcador atualizado com sucesso'
      redirect_to tags_path
    else
      @tag.valid?
      flash.now[:alert] = 'Erro ao atualizar marcador'

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag = Tag.find_by(id: params[:id])
    if @tag.destroy
      flash[:notice] = 'Marcador excluído com sucesso'
      redirect_to tags_path
    else
      flash.now[:alert] = 'Erro ao excluir marcador'
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end