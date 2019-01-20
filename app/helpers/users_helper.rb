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
  
  # 勤怠B：勤怠表示画面 在社時間差分式
  def time_10div(time)
    x = time.hour #例えば、8時間30分の8の値へアクセス。
    y = time.min #例えば、8時間30分の30の値へアクセス。
    y = y/60.to_f #60で割り、to_fメソッドを使用すると、30分→0.5、15分→0.25という値へアクセス出来る。
                  #to_fメソッドを使用しないと小数点以下の値へアクセス出来ないので注意。
    y = y.round(2) #この場合は小数点3桁目を四捨五入している。例)10分→0.17
    sum = x + y #最後に加算する。
    "#{sum}" #8時間30分→8.5へ変換される。
  end
end