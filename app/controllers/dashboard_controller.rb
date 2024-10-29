class DashboardController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def index
    @user = current_user
  end
end
