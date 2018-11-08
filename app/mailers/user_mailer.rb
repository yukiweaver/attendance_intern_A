#リスト 11.10: 生成されたUserメイラー
class UserMailer < ApplicationMailer
  
  #リスト 11.12: アカウント有効化リンクをメール送信
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end
  
  #リスト 12.7: パスワード再設定のリンクをメール送信する
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
