class UsersController < ApplicationController
  require "date"  #勤怠B：Dateクラスを使用
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,   #リスト 10.15 リスト 10.35 リスト 10.58
                                        :following, :followers]   #リスト 14.25
  before_action :correct_user,   only: [:edit, :update]   #リスト 10.25
  before_action :admin_user,     only: :destroy   #リスト 10.59: destroyアクションを管理者だけに限定
  
  #リスト 10.35 リスト 10.36 リスト 10.46: indexアクションでUsersをページネート
  def index
    @users = User.paginate(page: params[:page])
    # pf: 検索機能追加でコード変更
    #@users = User.where(activated: true).paginate(page: params[:page]).search(params[:search])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])    #リスト 13.23
    #@current_day = Date.today  #勤怠B：現在の年月日を取得
    
    #
    if params[:current_day] != nil
      @current_day = Date.strptime(params[:current_day])  #勤怠B：strptimeは「文字列」を「日付」に変換
    else
      @current_day = Date.new(Date.today.year, Date.today.month)
    end
    
    @last_month = @current_day.prev_month  #勤怠B：@current_dayからひと月前
    @next_month = @current_day.next_month  #勤怠B：@current_dayからひと月先
    @first_day = @current_day.beginning_of_month  #勤怠B：月初
    @last_day = @current_day.end_of_month  #勤怠B：月末
    @week = %w(日 月 火 水 木 金 土 日)  #勤怠B：%wで配列へ
    
    #@last_month = @current_day.prev_month.strftime("%Y:%m")
    #@next_month = @current_day.next_month
    #@current_day = Date.today.strftime("%Y")
    #@current_day2 = Date.today.strftime("%m")
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
      #@user.send_activation_email    #リスト 11.23: ユーザー登録にアカウント有効化を追加→リスト 11.36で変更
      #flash[:info] = "メールを確認してアカウントを有効にしてください。"
      flash[:info] = "新規登録しました。"
      #redirect_to root_url
      redirect_to @user
    else
      render 'new'
    end
  end
  
  #リスト 10.1: ユーザーのeditアクション
  def edit
    @user = User.find(params[:id])
  end
  
  #リスト 10.8: ユーザーのupdateアクションの初期実装
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "アカウント情報を更新しました。"   #リスト 10.12: ユーザーのupdateアクション
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  #リスト 10.58: 実際に動作するdestroyアクションを追加
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました。"
    redirect_to users_url
  end
  
  #リスト 14.25: followingアクション
  def following
    @title = "フォロー中"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  
  #リスト 14.25: followersアクション
  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  #勤怠B：基本情報の更新ページ
  def basic_info
    @user = User.find(params[:id])
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
      redirect_to(root_url) unless current_user.admin?
    end
end
