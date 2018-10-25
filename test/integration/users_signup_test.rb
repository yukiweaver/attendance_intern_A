require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do      #無効なユーザー登録に対するテスト
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",              #7.3.4.3で一部変更
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'   #演習7.3.4.1で追加
    assert_select 'div.alert'               #演習7.3.4.1で追加
    assert_select 'form[action="/signup"]'  #演習7.3.4.4で追加
  end
  
  test "valid signup information" do        #有効なユーザー登録に対するテスト
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end