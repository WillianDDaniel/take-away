class RestaurantsController < ApplicationController
  before_action :authenticate_user!

  def new
    @restaurant = Restaurant.new
  end
end