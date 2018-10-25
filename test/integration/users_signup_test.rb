require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
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
end