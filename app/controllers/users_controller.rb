class UsersController < ApplicationController
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
  end
  
  def new
     @user = User.new
  end
  
  #勤怠：二段階認証無効へ
  def create
    @user = User.new(user_params)
    if @user.save
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
      flash[:success] = "プロフィールを更新しました。"   #リスト 10.12: ユーザーのupdateアクション
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
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
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
