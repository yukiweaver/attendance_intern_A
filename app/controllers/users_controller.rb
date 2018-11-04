class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]   #リスト 10.15
  before_action :correct_user,   only: [:edit, :update]   #リスト 10.25
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
     @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
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
      flash[:success] = "Profile updated"   #リスト 10.12: ユーザーのupdateアクション
      redirect_to @user
    else
      render 'edit'
    end
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
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # リスト 10.25 正しいユーザーかどうか確認→リスト 10.28: 最終的なcorrect_userの実装
    def correct_user
      @user = User.find(params[:id])
       redirect_to(root_url) unless current_user?(@user)
    end
end
