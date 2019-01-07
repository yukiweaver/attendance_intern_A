module UsersHelper

  # リスト 10.38:渡されたユーザーのGravatar画像を返す
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  #勤怠B：基本情報の修正値取得時に小数二桁まで取得
  def basic_info_edit(time)
    format("%.2f", ((time.hour * 60.0) + time.min)/60) if !time.blank?
  end
  
  def current_day_edit(day)
    puts(@current_day.year, "年", @current_day.month, "月")
  end
end