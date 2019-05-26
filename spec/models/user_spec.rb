require 'rails_helper'

RSpec.describe User, type: :model do
  #名前、メールアドレス、パスワード、所属があれば有効
  it "is valid with a name, email, password, belong" do
    expect(build(:user)).to be_valid
  end
  
  # describe "email uniqueness" do
  #   it "is already email" do
  #     user = User.create(name: "test", email: "foo@bar.com", password: "password", belong: "テスト")
  #     dup_user = User.new(
  #       name: user.name,
  #       email: user.email.upcase,
  #       password: user.password,
  #       belong: user.belong)
  #     expext(dup_user).not_to be_valid
  #     expect(dup_user.errors[:email]).to include("はすでに存在します")
  #   end
  # end
  
  it "is already email" do
    User.create(
      name: "test_user",
      email: "email@gmail.com",
      password: "password",
      belong: "営業"
      )
      
    user = User.new(
      name: "test",
      email: "email@gmail.com",
      password: "password",
      belong: "開発"
    )
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end
end
