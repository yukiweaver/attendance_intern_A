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
      # モデルのname属性のみ配列で取得
      #@superiors = User.all.map { |user| user.name } 以下とほぼ同義
      @superiors = User.pluck :name
      if current_user.id == 2
        @superior = @superiors[2]
      elsif current_user.id == 3
        @superior = @superiors[1]
      else
        @superior = @superiors[1..2]
      end
    else
      flash[:warning] = "他ユーザーの編集ページへ遷移することはできません。"
      redirect_to "/attendance_edit/#{current_user.id}/?current_day=#{Date.today}"
    end
  end
  
  # 勤怠B：勤怠編集ページ更新
  # def attendance_update
  #   @user = User.find(params[:user][:id])
  #   attendance_params.each do |at, bt|
  #     @attendance = @user.attendances.find(at)
  #     # 管理者も他ユーザーも未来日を更新することはできない
  #     if current_user.admin? && @attendance.attendance_day.future?
  #     elsif current_user?(@user) && @attendance.attendance_day.future?
      
  #     # 出勤時間、退勤時間が空欄だと更新できない
  #     elsif bt["beginning_time"].blank? && bt["leaving_time"].blank?
  #     elsif bt["beginning_time"].blank? || bt["leaving_time"].blank?
  #       flash[:warning] = "無効な編集内容があります。"
        
  #     # 出勤時間より退勤時間の方が早い時間だと更新できない
  #     elsif bt["beginning_time"] > bt["leaving_time"]
  #       flash[:warning] = "出勤時間と退勤時間に誤りがあります。"
        
  #     # これら以外だと更新できる
  #     else @attendance.update_attributes(bt)
  #       flash[:success] = "勤怠編集情報を更新しました。しかし、本日以降は更新できません。"
  #       #redirect_to @user and return
  #     end
  #   end
  #   # リダイレクト先でhidden_fieldの値を受け取る
  #   redirect_to (user_url(params[:user][:id],current_day: params[:current_day]))
  # end
  
  # 勤怠A：勤怠編集更新
  def attendance_update
    @user = User.find(params[:id])
    if attendances_invalid?  # AttendancesHelper
      attendance_params.each do |at, bt|
        @attendance = @user.attendances.find(at)
        @attendance.update_attributes(bt)
        # binding.pry
      end
        flash[:success] = "勤怠編集情報を更新しました。"
        # リダイレクト先でhidden_fieldの値を受け取る
        redirect_to (user_url(params[:user][:id],current_day: params[:current_day]))
    else
        flash[:danger] = "不正な時間入力がありました、再入力してください。"
        redirect_to (user_url(params[:user][:id],current_day: params[:current_day]))
    end
  end
  
  # 勤怠A：出勤者一覧
  def attendance_index
    @users = User.all.includes(:attendances)
    if current_user.admin?
      #@user = @users.attendances.all
    else
      flash[:warning] = "出勤者一覧ページへは遷移できません。"
      redirect_to current_user
    end
  end
  
  # def overtime
  #   @user = User.find(params[:id])
  # end
  
  # 勤怠A：一日分の残業申請
  # users/show.html.erbのhidden_fieldのパラメータ取得
  def overtime_update
    @user = User.find(params[:attendance][:user_id])
    @attendance = @user.attendances.find(params[:attendance][:id])
    # binding.pry
    if params[:attendance][:scheduled_end_time].blank? || params[:attendance][:instructor_test].blank?
      flash[:warning] = "必須箇所が空欄です。"
      redirect_to (user_url(params[:attendance][:user_id], current_day: params[:current_day]))
    else
      # カラムapplication_statusを申請中の「nothing」→「applying」に変更
      @attendance.applying!
      @attendance.update_attributes(overtime_params)
      flash[:success] = "残業申請が完了しました。"
      redirect_to (user_url(params[:attendance][:user_id], current_day: params[:current_day]))and return
    end
  end
  # @user.update_attribute = { :username = 'A' }
  # {"scheduled_end_time"=>"11:11", "next_day"=>"1", "business_outline"=>"", "instructor_test"=>"上長B"
  
  # 一月分の勤怠申請
  def month_update
    @user = User.find(params[:one_month_attendance][:application_user_id])
    if params[:one_month_attendance][:authorizer_user_test].blank?
      flash[:warning] = "指示者確認欄が空白です。"
      redirect_to @user and return
    end
    
    @one_month_attendance = OneMonthAttendance.find_by(application_user_id: params[:one_month_attendance][:application_user_id],
                                                       application_date: params[:one_month_attendance][:application_date])
    if @one_month_attendance.nil?
      @one_month_attendance = OneMonthAttendance.new(one_month_attendance_params)
      if @one_month_attendance.save
        flash[:success] = "勤怠申請が完了しました。"
      else
        flash[:danger] = "勤怠申請に失敗しました。"
      end
    else
      flash[:warning] = "すでに申請しています。"
    end
    redirect_to @user
  end
  
  def authorizer_overtime_update
  end
  
  private
  
    # 勤怠B：Strong Parameters fields_forに伴い、user時のコードに比べ、工夫が必要
    def attendance_params
      params.permit(attendances: [:beginning_time, :leaving_time, :note, :next_day, :attendance_test])[:attendances]
    end
    # def attendance_params
    #   params.require(:attendance).permit(:beginning_time, :leaving_time)
    # end
    
    # 勤怠A：一日分の残業申請
    def overtime_params
      params.require(:attendance).permit(:scheduled_end_time, :leaving_next_day, :business_outline, :instructor_test)
      # params.permit(attendances: [:scheduled_end_time, :next_day, :business_outline, :instructor_test])[:attendances]
    end
    
    # 勤怠A：月の勤怠申請
    def one_month_attendance_params
      params.require(:one_month_attendance).permit(:application_user_id, :authorizer_user_test, :application_date)
    end
end
