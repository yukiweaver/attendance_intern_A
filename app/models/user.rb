class User < ApplicationRecord
  has_many :microposts, dependent: :destroy    #リスト 13.11 リスト 13.19
  #リスト 14.2: 能動的関係に対して1対多 (has_many) の関連付けを実装する
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  #リスト 14.12: 受動的関係を使ってuser.followersを実装する
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  #リスト 14.8: Userモデルにfollowingの関連付けを追加する
  has_many :following, through: :active_relationships, source: :followed
  #リスト 14.12: 受動的関係を使ってuser.followersを実装する
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token    #リスト 11.3 リスト 12.6
  before_save   :downcase_email   #リスト 11.3:コード変更 データベースに保存する前にemail属性を強制的に小文字に変換
  before_create :create_activation_digest   #リスト 11.3
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }      #uniqueness: でemailの一意性を検証する
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true    #リスト 10.13: パスワードが空のままでも更新できる処理
    
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
  
  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  #リスト 13.46: マイクロポストのステータスフィードを実装するための準備
  def feed
    Micropost.where("user_id = ?", id)
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

  
  private

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
