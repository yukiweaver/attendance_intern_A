class PasswordResetsController < ApplicationController
  
  before_action :get_user,   only: [:edit, :update]   #リスト 12.15
  before_action :valid_user, only: [:edit, :update]   #リスト 12.15
  before_action :check_expiration, only: [:edit, :update]    # リスト 12.16:(1) への対応

  def new
  end
  
  #リスト 12.5: パスワード再設定用のcreateアクション
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "届いたメールを確認してパスワードを再設定してください。"
      redirect_to root_url
    else
      flash.now[:danger] = "入力されたメールアドレスが見当たりません。"
      render 'new'
    end
  end

  def edit
  end
  
  #リスト 12.16: パスワード再設定のupdateアクション
  def update
    if params[:user][:password].empty?                  # (3)  への対応
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)          # (4) への対応
      log_in @user
      flash[:success] = "パスワードを再設定しました。"
      redirect_to @user
    else
      render 'edit'                                     # (2) への対応
    end
  end
  
  private
    
    #リスト 12.16
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # beforeフィルタ
  
    #リスト 12.15
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # リスト 12.15:正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # リスト 12.16:トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "パスワード再設定の有効期限が終了しました。"
        redirect_to new_password_reset_url
      end
    end
end