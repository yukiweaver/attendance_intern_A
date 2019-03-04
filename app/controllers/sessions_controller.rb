class SessionsController < ApplicationController

  def new
  end
  
  #勤怠：二段階認証無効へ
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)  #リスト 9.23: [remember me] チェックボックスの送信結果を処理
      if user.admin?
        redirect_to root_url
      else
        redirect_back_or user   #リスト 10.32: フレンドリーフォワーディングを備える
      end
    else
      flash.now[:danger] = 'メールアドレス、またはパスワードが正しくありません。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?   #リスト 9.16: ログイン中の場合のみログアウトする
    redirect_to root_url
  end
end