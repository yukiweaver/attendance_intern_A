class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?    #リスト 11.32: 有効でないユーザーがログインすることのないようにする
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)  #リスト 9.23: [remember me] チェックボックスの送信結果を処理
        redirect_back_or user   #リスト 10.32: フレンドリーフォワーディングを備える
      else
        message  = "アカウントが有効化されていません。 "
        message += "メールのリンクを確認してください。"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレス、パスワードが正しくありません。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?   #リスト 9.16: ログイン中の場合のみログアウトする
    redirect_to root_url
  end
end