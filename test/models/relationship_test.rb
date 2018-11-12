require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
  end
  
  #リスト 14.4: Relationshipモデルのバリデーションをテストする
  test "should be valid" do
    assert @relationship.valid?
  end
  
  #リスト 14.4: Relationshipモデルのバリデーションをテストする
  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end
  
  #リスト 14.4: Relationshipモデルのバリデーションをテストする
  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end