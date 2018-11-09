#リスト 13.2: 自動生成されたMicropostモデル
class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true    #リスト 13.5
  validates :content, presence: true, length: { maximum: 140 }    #リスト 13.8
end
