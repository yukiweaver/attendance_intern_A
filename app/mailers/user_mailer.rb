#リスト 11.10: 生成されたUserメイラー
class UserMailer < ApplicationMailer
  
  #リスト 11.12: アカウント有効化リンクをメール送信
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
