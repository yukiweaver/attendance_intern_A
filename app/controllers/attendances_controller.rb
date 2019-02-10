class AttendancesController < ApplicationController
  require "date"
  require "time"
  include AttendancesHelper
  
  # 勤怠B：勤怠編集ページ
  def attendance_edit
    @user = User.find(params[:id])
    
    # 管理者のみ全ユーザーの勤怠編集ページに遷移可能 他ユーザーは自分の編集ページのみ遷移可能
    if current_user.admin? || current_user?(@user)
      
      # 勤怠編集　パラメーターで先月、来月も表示可
      if params[:current_day] != nil
        @current_day = Date.strptime(params[:current_day])  #勤怠B：strptimeは「文字列」を「日付」に変換
      else
        #以下だと月をまたぐと反映されない
        #@current_day = Date.new(Date.today.year, Date.today.month)
        @current_day = Date.today
      end
      
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
        # 本番環境でバグ　orderメソッド追加で昇順へ
        @date = @user.attendances.where("attendance_day >= ? and attendance_day <= ?", @first_day, @last_day).order(:attendance_day)
      end
    else
      flash[:warning] = "他ユーザーの編集ページへ遷移することはできません。"
      redirect_to "/attendance_edit/#{current_user.id}/?current_day=#{Date.today}"
    end
  end
  
  # 勤怠B：勤怠編集ページ更新
  def attendance_update
    @user = User.find(params[:user][:id])
    attendance_params.each do |at, bt|
      @attendance = @user.attendances.find(at)
      # 管理者も他ユーザーも未来日を更新することはできない
      if current_user.admin? && @attendance.attendance_day.future?
      elsif current_user?(@user) && @attendance.attendance_day.future?
      
      # 出勤時間、退勤時間が空欄だと更新できない
      elsif bt["beginning_time"].blank? && bt["leaving_time"].blank?
      elsif bt["beginning_time"].blank? || bt["leaving_time"].blank?
        flash[:warning] = "無効な編集内容があります。"
        
      # 出勤時間より退勤時間の方が早い時間だと更新できない
      elsif bt["beginning_time"] > bt["leaving_time"]
        flash[:warning] = "出勤時間と退勤時間に誤りがあります。"
        
      # これら以外だと更新できる
      else @attendance.update_attributes(bt)
        flash[:success] = "勤怠編集情報を更新しました。しかし、本日以降は更新できません。"
        #redirect_to @user and return
      end
    end
    # リダイレクト先でhidden_fieldの値を受け取る
    redirect_to (user_url(params[:user][:id],current_day: params[:current_day]))
  end
  
  def attendance_index
    
  end
  
  
  private
  
    # 勤怠B：Strong Parameters fields_forに伴い、user時のコードに比べ、工夫が必要
    def attendance_params
      params.permit(attendances: [:beginning_time, :leaving_time])[:attendances]
    end
    # def attendance_params
    #   params.require(:attendance).permit(:beginning_time, :leaving_time)
    # end
end
