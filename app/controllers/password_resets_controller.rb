class PasswordResetsController < ApplicationController
  
  before_action :get_user,   only: [:edit, :update]   #リスト 12.15
  before_action :valid_user, only: [:edit, :update]   #リスト 12.15

  def new
  end
  
  #リスト 12.5: パスワード再設定用のcreateアクション
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end
  
  private
  
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
end