module UsersHelper

  # リスト 10.38:渡されたユーザーのGravatar画像を返す
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  # 基本情報の修正値取得時に小数二桁まで取得
  def basic_info_edit(time)
    format("%.2f", ((time.hour * 60.0) + time.min)/60) if !time.blank?
  end
  
  # 勤怠表示画面 在社時間 差分式
  def company_time_edit(time)
    format("%.2f",(time)/3600)
  end
  
  # 勤怠表示画面 在社時間の合計 フォーマットヘルパー使用→指定の桁で丸める
  def total_company_edit(time)
    number_with_precision time, precision:2
  end
  
  # 勤怠表示画面 時間外時間
  def overtime_hours(day, time, time2)
    if day.blank?
      format("%.2f", (time.hour.to_f + (time.min.to_f / 60)) - (time2.hour.to_f + (time2.min.to_f / 60)))
    else
      format("%.2f", (time.hour.to_f + (time.min.to_f / 60)) - (time2.hour.to_f + (time2.min.to_f / 60))+24.0)
    end
  end
  
  # ログインしているユーザーのみ
  def overtime_test(user, current_user)
    user.id == current_user.id
  end
end