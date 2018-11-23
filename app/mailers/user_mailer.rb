#リスト 11.10: 生成されたUserメイラー
class UserMailer < ApplicationMailer
  
  #リスト 11.12: アカウント有効化リンクをメール送信
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "アカウント有効化"
  end
  
  #リスト 12.7: パスワード再設定のリンクをメール送信する
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "メールを確認してパスワードを再設定してください。"
  end
end
