class AttendancesController < ApplicationController
  require "date"
  require "time"
  include AttendancesHelper
  
  def edit
    @user = User.find(params[:id])
    @attendance = @user.attendances.build
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
  end
  
  # 勤怠B：勤怠編集ページ更新
  def update
    @user = User.find(params[:id])
    @attendance = @user.attendances.find(params[:id])
    if @attendance.update_attributes(attendance_params)
      flash[:success] = "勤怠編集情報を更新しました。"   #リスト 10.12: ユーザーのupdateアクション
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
    # 勤怠B：Strong Parameters
     #def attendance_params
       #params.require(:attendance).permit(:beginning_time, :leaving_time)
     #end
     def attendance_params
      params.permit(attendances: [:beginning_time, :leaving_time, :id, :user_id])[:attendances]
     end
    # def user_params
    #   params.require(:user).permit(:name, :email, :belong, :password,
    #                               :password_confirmation, :designate_work_time, :basic_work_time,
    #                               attendances_attributes: [:beginning_time, :leaving_time])
    # end
end
