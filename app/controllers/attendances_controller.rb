class AttendancesController < ApplicationController
  require "date"
  require "time"
  include AttendancesHelper
  
  # 勤怠B：勤怠編集ページ
  def attendance_edit
    @user = User.find(params[:id])
    #@attendance = Attendance.find(params[:id])
    @current_day = Date.new(Date.today.year, Date.today.month, Date.today.day)
    @last_month = @current_day.last_month
    @next_month = @current_day.next_month
    @first_day = @current_day.beginning_of_month
    @last_day = @current_day.end_of_month
    @week = %w(日 月 火 水 木 金 土 )
    
    (@first_day..@last_day).each do |d|
      if not @user.attendances.any?{|a| a.attendance_day == d}
        #@attendance = Attendance.new(attendance_day: d, user_id: @user.id) 以下の@attendanceと同意味
        @attendance1 = @user.attendances.build(attendance_day: d)
        @attendance1.save
      end
      @date = @user.attendances.where("attendance_day >= ? and attendance_day <= ?", @first_day, @last_day)
    end
    
    # 勤怠B：在社時間と在社時間の合計、出勤日数　在社時間@company_timeはviewでは使用しない
    @date.each do |date|
      if date.beginning_time != nil && date.leaving_time != nil
        @company_time = date.leaving_time - date.beginning_time
        #@start_company_time = 0
        @total_company_time = (@total_company_time.to_f + @company_time)
        @attendance_count = @user.attendances.where("beginning_time != ? and leaving_time != ?", nil?, nil?).count
      end
    end
  end
  
  #勤怠B：勤怠編集ページ更新
  # def attendance_update
  #   @user = User.find(params[:id])
  #   @attendance = @user.attendances.where(attendance_day: Time.now.beginning_of_month..Time.now.end_of_month)
  #   @attendance.each do |at|
  #     if at.update_attributes(attendance_params)
  #       flash[:success] = "勤怠編集情報を更新しました。"
  #       redirect_to @user
  #     else
  #       render 'attendance_edit'
  #     end
  #   end
  # end
  
  # 勤怠B：勤怠編集ページ更新
  def attendance_update
    @user = User.find(params[:id])
    attendance_params.each do |at, bt|
      @attendance = @user.attendances.find(at)
      if @attendance.update_attributes(bt)
        flash[:success] = "勤怠編集情報を更新しました。"
        #redirect_to @user and return
      end
    end
    redirect_to @user
  end
  
  
  private
  
    # 勤怠B：Strong Parameters
    # def attendance_params
    #   params.require(:attendance).permit(:beginning_time, :leaving_time)
    # end
    def attendance_params
      params.permit(attendances: [:beginning_time, :leaving_time])[:attendances]
    end
    # def user_params
    #   params.require(:user).permit(:name, :email, :belong, :password,
    #                               :password_confirmation, :designate_work_time, :basic_work_time,
    #                               attendances_attributes: [:beginning_time, :leaving_time])
    # end
end
