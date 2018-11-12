require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  
  #リスト 14.31: リレーションシップの基本的なアクセス制御に対するテスト
  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end
  
  #リスト 14.31: リレーションシップの基本的なアクセス制御に対するテスト
  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
end