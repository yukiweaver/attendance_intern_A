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
    @week = %w(日 月 火 水 木 金 土 )
    
    (@first_day..@last_day).each do |d|
      if not @user.attendances.any?{|a| a.attendance_day == d}
        @attendance1 = @user.attendances.build(attendance_day: d)
        @attendance1.save
      end
      @date = @user.attendances.where("attendance_day >= ? and attendance_day <= ?", @first_day, @last_day)
    end
  end
  
  def update
    @user = User.find(params[:id])
    @attendance = Attendance.find(paramas:[:id])
  end
end
