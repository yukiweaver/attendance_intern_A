require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  #リスト 10.20: editアクションの保護に対するテスト
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  #リスト 10.20: updateアクションの保護に対するテスト
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
