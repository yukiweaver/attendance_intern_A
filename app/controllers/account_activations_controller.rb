class AccountActivationsController < ApplicationController
  
  #リスト 11.31: アカウントを有効化するeditアクション
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate   #リスト 11.37: ユーザーモデルオブジェクト経由でアカウントを有効化
      log_in user
      flash[:success] = "アカウントが有効になりました。"
      redirect_to user
    else
      flash[:danger] = "アカウント有効化に失敗しました。"
      redirect_to root_url
    end
  end
end