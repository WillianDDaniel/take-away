class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  private

  def authorize_owners!
    unless current_user.owner? && current_user.restaurant
      redirect_to dashboard_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :last_name, :document_number])
  end
end
