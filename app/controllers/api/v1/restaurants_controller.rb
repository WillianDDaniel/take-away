class Api::V1::RestaurantsController < ActionController::API
  def show
    restaurant = Restaurant.find_by(code: params[:code])

    unless restaurant
      render json: {
        error: 'Restaurante não encontrado',
        message: 'Verifique o código do restaurante e tente novamente'
      }, status: :not_found

      return
    end

    render json: restaurant.as_json(only: :brand_name), status: :ok
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:code)
  end
end