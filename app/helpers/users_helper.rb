module UsersHelper

  # 渡されたユーザーのGravatar画像を返す
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
    # 在社時間計上用
  def working_hours(a,b)
    arriving_at = Time.mktime(a.year, a.month, a.day, a.hour, a.min, 0, 0)
    leaving_at = Time.mktime(b.year, b.month, b.day, b.hour, b.min, 0, 0)
    # (((leaving_at - arriving_at) / 60) / 60).truncate(2)
    (((leaving_at - arriving_at) / 60) / 60).to_d.truncate(2).to_f  
  end
  
  # 引数の時刻データの秒を０にして差を求める
  def times(x,y)
    c = Time.mktime(x.year, x.month, x.day, x.hour, x.min, 0, 0)
    d = Time.mktime(y.year, y.month, y.day, y.hour, y.min, 0, 0)
    (d - c).to_i
  end
  
  # 基本時間などの時刻データを指定の１０段階表示にする
  def basic_info_time(t)
    format("%.2f", ((t.hour * 60.0) + t.min)/60) if !t.blank?
  end
end
