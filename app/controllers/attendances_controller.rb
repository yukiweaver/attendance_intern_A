class AttendancesController < ApplicationController
  require "date"
  require "time"
  include AttendancesHelper
  
  def edit
    @user = User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    @current_day = Date.new(Date.today.year, Date.today.month, Date.today.day)
    @last_month = @current_day.last_month
    @next_month = @current_day.next_month
    @first_day = @current_day.beginning_of_month
    @last_day = @current_day.end_of_month
  end
end
