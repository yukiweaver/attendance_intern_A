class UsersController < ApplicationController
  require "date"
  require "time"
  include UsersHelper
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,   #リスト 10.15 リスト 10.35 リスト 10.58
                                        :following, :followers]   #リスト 14.25
  #before_action :correct_user,   only: :update   #リスト 10.25
  before_action :admin_user,     only: [:destroy, :index]   #リスト 10.59: destroyアクションを管理者だけに限定
  
  #リスト 10.35 リスト 10.36 リスト 10.46: indexアクションでUsersをページネート
  # def index
  #   @users = User.paginate(page: params[:page])
  #   if current_user.admin?
  #     @user = current_user
  #   else
  #     flash[:warning] = "ユーザー一覧ページへ遷移することはできません。"
  #     redirect_to current_user
  #   end
  # end
  
  def index
    @users = User.all
    if params[:id].present?
      @user = User.find(params[:id])
    end
  end
  
  def show
    @user = User.find(params[:id])
    
    # 管理者のみ他ユーザーの勤怠表示画面に遷移可能、他ユーザーは自分の勤怠画面のみ
    if current_user.admin? || current_user?(@user)
      
      if params[:current_day] != nil
        @current_day = Date.strptime(params[:current_day])  #勤怠B：strptimeは「文字列」を「日付」に変換
      else
        #以下だと月をまたぐと反映されない
        #@current_day = Date.new(Date.today.year, Date.today.month)
        @current_day = Date.today
      end
      
      @last_month = @current_day.prev_month  #@current_dayからひと月前
      @next_month = @current_day.next_month  #@current_dayからひと月先
      @first_day = @current_day.beginning_of_month  #月初
      @last_day = @current_day.end_of_month  #月末
      @week = %w(日 月 火 水 木 金 土 日)  #%wで配列へ
      
      # 月初から月末までの繰り返しをブロック変数dに格納
      (@first_day..@last_day).each do |d|
        if not @user.attendances.any?{|a| a.attendance_day == d}
          #@attendance = Attendance.new(attendance_day: d, user_id: @user.id) 以下の@attendanceと同意味
          @attendance = @user.attendances.build(attendance_day: d)
          @attendance.save
        end
        # 本番環境でバグ　orderメソッド追加で昇順へ　
        @date = @user.attendances.where("attendance_day >= ? and attendance_day <= ?", @first_day, @last_day).order(:attendance_day)
      end
      
      # 在社時間と在社時間の合計、出勤日数　在社時間@company_timeはviewでは使用しない
      i = 0
      @date.each do |date|
        if date.beginning_time != nil && date.leaving_time != nil
          @company_time = date.leaving_time - date.beginning_time
          #@start_company_time = 0
          @total_company_time = (@total_company_time.to_f + @company_time)
          # 出勤日数が以下の定義だと本番環境で適用されない（postgreSQL）
          #@attendance_count = @user.attendances.where("beginning_time != ? and leaving_time != ? and attendance_day >= ? and attendance_day <= ?", nil?, nil?, @first_day, @last_day).count
          #@attendance_count = @user.attendances.where.not(beginning_time: nil?).where.not(leaving_time: nil?).where(attendance_day: @first_day..@last_day).count
          i += 1
          @attendance_count = i
        end
      end
    else
      redirect_to current_user
      flash[:warning] = "他ユーザーの勤怠表示ページへ遷移することはできません。"
    end
  end
  
  # 勤怠B:出社ボタン押込み時の処理
  def beginning_time
    @user = User.find(params[:id])
    @attendance = Attendance.all
    @beginning_time = @user.attendances.find_by(attendance_day: Date.today)
    if @beginning_time.update_attributes(beginning_time: Time.new(Time.now.year, Time.now.month, Time.now.day, 
      Time.now.hour, Time.now.min))
      flash[:info] = "出社しました。"
      redirect_to @user
    end
  end
  
  # 勤怠B：退社ボタン押し込み時の処理
  def leaving_time
  @user = User.find(params[:id])
    @attendance = Attendance.all
    @leaving_time = @user.attendances.find_by(attendance_day: Date.today)
    if @leaving_time.update_attributes(leaving_time: Time.new(Time.now.year, Time.now.month, Time.now.day, 
      Time.now.hour, Time.now.min))
      flash[:info] = "退社しました。"
      redirect_to @user
    end
  end
  
  def new
     @user = User.new
  end
  
  # リスト 7.19: createアクションでStrong Parametersを使う
  # 勤怠：二段階認証無効へ
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:info] = "新規登録しました。"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  #リスト 10.1: ユーザーのeditアクション
  def edit
    @user = User.find(params[:id])
    if @user.id == current_user.id
    else
      flash[:warning] = "他ユーザーの編集ページへ遷移することはできません。"
      redirect_to "/users/#{current_user.id}/edit"
    end
  end
  
  #リスト 10.8: ユーザーのupdateアクションの初期実装
  def update
  @user = User.find(params[:id])
    if current_user.admin?
      if @user.update_attributes(user_params)
        flash[:success] = "アカウント情報を更新しました。"   #リスト 10.12: ユーザーのupdateアクション
        redirect_to users_url
      else
        render 'index'
      end
    else
       if @user.update_attributes(user_params)
         flash[:success] = "アカウント情報を更新しました。"
         redirect_to @user
       else
         render 'edit'
       end
    end
  end
  
  #リスト 10.58: 実際に動作するdestroyアクションを追加
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました。"
    redirect_to users_url
  end
  
  #勤怠B：基本情報の更新ページ
  def basic_info
    @user = User.find(params[:id])
    if current_user.admin?
    else
      flash[:danger] = "基本情報更新ページへ遷移することはできません。"
      redirect_to @user
    end
  end
  
  #勤怠B：基本情報を編集
  def basic_info_update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to @user
    else
      flash[:danger] = "基本情報の更新に失敗しました。"
      redirect_to @user
    end
  end
  
  private
  
    # リスト 7.19: createアクションでStrong Parametersを使う
    # 勤怠：Strong Parametersにbelong,designate_work_time,basic_work_time追加
    def user_params
      params.require(:user).permit(:name, :email, :belong, :password,
                                   :password_confirmation, :designate_work_time, :basic_work_time)
    end
    
    
    #リスト 10.15: beforeフィルターにlogged_in_userを追加
    # beforeアクション
    
    # リスト 10.25 正しいユーザーかどうか確認→リスト 10.28: 最終的なcorrect_userの実装
    def correct_user
      @user = User.find(params[:id])
       redirect_to(root_url) unless current_user?(@user)
    end
    
    # リスト 10.59:管理者かどうか確認
    def admin_user
      @user = current_user
      redirect_to(root_url) unless current_user.admin?
    end
end
