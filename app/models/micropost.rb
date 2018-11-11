#リスト 13.2: 自動生成されたMicropostモデル
class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }   #リスト 13.17: マイクロポストを順序付ける
  mount_uploader :picture, PictureUploader    #リスト 13.59: Micropostモデルに画像を追加
  validates :user_id, presence: true    #リスト 13.5
  validates :content, presence: true, length: { maximum: 140 }    #リスト 13.8
  validate  :picture_size   #リスト 13.65: 画像に対するバリデーションを追加
  
  private

    # リスト 13.65:アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
