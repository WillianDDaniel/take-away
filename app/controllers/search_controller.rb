class SearchController < ApplicationController
  layout 'dashboard'

  def index
    @query = search_params[:query]

    if @query.present?
      @dishes = current_user.restaurant.dishes.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%")
      @beverages = current_user.restaurant.beverages.where("name LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%")
    else
      @dishes = []
      @beverages = []
    end
  end

  private

  def search_params
    params.permit(:query, :commit)
  end
end