class User < ApplicationRecord
  #勤怠B：attendancesテーブルと紐付け。userがattendanceを複数所有。
  has_many :attendances, dependent: :destroy,
                         foreign_key: "user_id"
  attr_accessor :remember_token, :activation_token, :reset_token    #リスト 11.3 リスト 12.6
  before_save   :downcase_email   #リスト 11.3:コード変更 データベースに保存する前にemail属性を強制的に小文字に変換
  before_create :create_activation_digest   #リスト 11.3
  validates :name,  presence: true, length: { maximum: 50 }
  validates :belong, presence: true, length: { maximum: 30 }  # 勤怠：所属に制限
  validates :designate_work_time, presence: true, allow_nil: true  #勤怠B：指定勤務時間に制限
  validates :basic_work_time, presence: true, allow_nil: true  #勤怠B：基本勤務時間に制限
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }      #uniqueness: でemailの一意性を検証する
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true    #リスト 10.13: パスワードが空のままでも更新できる処理
  
  # 勤怠A：csvファイル読み込み selfはUserでも可
  def self.import(file)
    # CSVファイルからデータを読み込む
    CSV.foreach(file.path, headers: true) do |row|
      # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      user = find_by(id: row["id"]) || new
      # CSVからname、emailなどのデータを取得し、設定する
      # ActiveSupportのHash拡張であるslice、ハッシュから指定した値だけを取り出す
      user.attributes = row.to_hash.slice(*updatable_attributes)
      #保存する
      if user.valid?
        user.save!
      else
        Rails.logger.warn(user.errors.inspect)
      end
    end
  end
    
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す リスト 9.2: トークン生成用メソッドを追加
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する リスト 9.3: rememberメソッドをUserモデルに追加
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す リスト 9.6: authenticated?をUserモデルに追加
  # リスト 11.26:トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する リスト 9.11: forgetメソッドをUserモデルに追加
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # リスト 11.35:アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  # リスト 11.35:有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # リスト 12.6:パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # リスト 12.6:パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # リスト 12.17:パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # リスト 14.44: とりあえず動くフィードの実装 ユーザーのステータスフィードを返す
  # リスト 14.46: whereメソッド内の変数に、キーと値のペアを使う
  # リスト 14.47: フィードの最終的な実装
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  # リスト 14.10:ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # リスト 14.10:ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # リスト 14.10:現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  
  # pf: 検索機能
  def self.search(search) #ここでのself.はUser.を意味する
    if search
      where(['name LIKE ?', "%#{search}%"]) #検索とnameの部分一致を表示。User.は省略
    else
      all #全て表示。User.は省略
    end
  end

  
  private
  
    # csvファイル 更新を許可するカラムを定義
    def self.updatable_attributes
      ["name", "email", "belong", "number", "card_number", "basic_work_time", "designate_work_time",
      "designate_end_time", "admin", "password"]
    end

    # リスト 11.3:メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # リスト 11.3:有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
