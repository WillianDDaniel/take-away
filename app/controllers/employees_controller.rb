class EmployeesController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :authorize_owners!

  def index
    @employees = current_user.restaurant.employees
  end

  def new
    @restaurant = current_user.restaurant
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.restaurant = current_user.restaurant

    if @employee.save
      flash[:notice] = 'Funcionário cadastrado com sucesso'
      redirect_to employees_path
    else
      @employee.valid?
      flash.now[:alert] = 'Erro ao cadastrar funcionário'

      @restaurant = current_user.restaurant
      render :new, status: :unprocessable_entity
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:email, :doc_number)
  end
end