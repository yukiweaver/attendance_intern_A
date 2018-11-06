#リスト 11.9: 生成されたApplicationメイラー
class ApplicationMailer < ActionMailer::Base
  default from: "noreply@example.com"   #リスト 11.11: fromアドレスのデフォルト値を更新
  layout 'mailer'
end
