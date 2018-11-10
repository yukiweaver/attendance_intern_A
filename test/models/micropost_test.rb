require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    #リスト 13.12: 慣習的に正しくマイクロポストを作成
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end
  
  #リスト 13.4: 新しいMicropostの有効性に対するテスト
  test "should be valid" do
    assert @micropost.valid?
  end
  
  #リスト 13.4: 新しいMicropostの有効性に対するテスト
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  #リスト 13.7: Micropostモデルのバリデーションに対するテスト
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end
  
  #リスト 13.7: Micropostモデルのバリデーションに対するテスト
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
end