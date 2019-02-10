#リスト 10.43: データベース上にサンプルユーザーを生成するRailsタスク
#リスト 11.4: サンプルユーザーを最初から有効にしておく
User.create!(name:  "植野 裕樹",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             #activated: true,
             belong: "営業",
             designate_work_time: Time.zone.parse("10:00"),
             designate_end_time: Time.zone.parse("20:00"),
             basic_work_time: Time.zone.parse("10:00"),
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              #activated: true,
              belong: "営業",
              designate_work_time: Time.zone.parse("10:00"),
              designate_end_time: Time.zone.parse("20:00"),
              basic_work_time: Time.zone.parse("10:00"),
              activated_at: Time.zone.now)
end


