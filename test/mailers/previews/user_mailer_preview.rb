#リスト 11.17: Userメイラープレビュー (自動生成)
# Preview all emails at http://9d60c56dbede4e71b7f2a4d1da97ab9a.vfs.cloud9.us-east-2.amazonaws.com/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://9d60c56dbede4e71b7f2a4d1da97ab9a.vfs.cloud9.us-east-2.amazonaws.com/rails/mailers/user_mailer/account_activation
  #リスト 11.18: アカウント有効化のプレビューメソッド (完成)
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://9d60c56dbede4e71b7f2a4d1da97ab9a.vfs.cloud9.us-east-2.amazonaws.com/rails/mailers/user_mailer/password_reset
  #リスト 12.10: パスワード再設定のプレビューメソッド (完成)
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end
end
