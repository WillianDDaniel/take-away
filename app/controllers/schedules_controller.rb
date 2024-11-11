class SchedulesController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :authorize_owners!

  def index
    @schedules = current_user.restaurant.schedules
  end

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)

    @schedule.restaurant = current_user.restaurant

    if @schedule.save
      flash[:notice] = 'Horários cadastrados com sucesso'
      redirect_to schedules_path
    else
      @schedule.valid?
      flash[:alert] = 'Erro ao cadastrar horários'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @schedule = Schedule.find_by(id: params[:id])

    if @schedule.nil? || @schedule.restaurant != current_user.restaurant
      redirect_to schedules_path
    end
  end

  def update
    @schedule = Schedule.find(params[:id])

    if @schedule.update(schedule_params)
      flash[:notice] = 'Horário atualizado com sucesso'
      redirect_to schedules_path
    else
      @schedule.valid?
      flash[:alert] = 'Erro ao atualizar horário'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @schedule = Schedule.find(params[:id])

    if @schedule.destroy
      flash[:notice] = 'Horários excluídos com sucesso'
    else
      flash[:alert] = 'Erro ao excluir horário'
    end

    redirect_to schedules_path
  end

  private

  def schedule_params
    params.require(:schedule).permit(:week_day, :open_time, :close_time)
  end
end