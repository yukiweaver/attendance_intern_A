class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]   #リスト 10.15 リスト 10.35 リスト 10.58
  before_action :correct_user,   only: [:edit, :update]   #リスト 10.25
  before_action :admin_user,     only: :destroy   #リスト 10.59: destroyアクションを管理者だけに限定
  
  #リスト 10.35 リスト 10.36 リスト 10.46: indexアクションでUsersをページネート
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
     @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now    #リスト 11.23: ユーザー登録にアカウント有効化を追加
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url   
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
      flash[:success] = "Profile updated"   #リスト 10.12: ユーザーのupdateアクション
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  #リスト 10.58: 実際に動作するdestroyアクションを追加
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    #リスト 10.15: beforeフィルターにlogged_in_userを追加
    # beforeアクション

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location    #リスト 10.31
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
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
