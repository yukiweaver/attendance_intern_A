class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token    #リスト 11.3
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
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する リスト 9.11: forgetメソッドをUserモデルに追加
  def forget
    update_attribute(:remember_digest, nil)
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
