FactoryBot.define do
  factory :user do
    name { "test name" }
    sequence(:email) { |n| "user#{n+1}@email.com" }
    password { "password" }
    belong {"test"}
  end
end
