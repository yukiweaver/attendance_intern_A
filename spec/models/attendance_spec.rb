require 'rails_helper'

RSpec.describe Attendance, type: :model do
  # 外部キーであるuser_idがあれば有効
  it "is user_id valid" do
    user = FactoryBot.create(:user)
    attendance = user.attendances.build(user_id: 1)
    expect(attendance).to be_valid
  end
end
