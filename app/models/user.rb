class User < ApplicationRecord
    before_save { email.downcase! }                 #データベースに保存する前にemail属性を強制的に小文字に変換
    validates :name,  presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false }      #uniqueness: でemailの一意性を検証する
end
