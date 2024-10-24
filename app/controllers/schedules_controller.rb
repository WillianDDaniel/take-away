class SchedulesController < ApplicationController
  before_action :authenticate_user!

  def index
    @schedules = Schedule.all
  end

  def new
    redirect_to dashboard_path unless current_user.restaurant

    if current_user.restaurant && current_user.restaurant.schedules.exists?
      redirect_to dashboard_path
    end

    @schedules = []
    (0..6).each do |day|
      @schedule = Schedule.new
      @schedule.week_day = day
      @schedules << @schedule
    end
  end

  def create
    schedule_params['schedules'].to_a.each do |schedule|

      schedule[:restaurant] = current_user.restaurant
      @schedule = Schedule.new(schedule)
      @schedule.save
    end

    redirect_to dashboard_path
  end

  private

  def schedule_params
    params.require(:schedule).permit(schedules: [:week_day, :open_time, :close_time])
  end
end