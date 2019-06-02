json.array! @approval_histories do |ah|
  json.attendance_day ah.attendance_day
  json.first_beginning_time ah.first_beginning_time
  json.first_leaving_time ah.first_leaving_time
  json.beginning_time ah.beginning_time
  json.leaving_time ah.leaving_time
  json.authorizer_user User.find(ah.attendance_test).name if not ah.attendance_test.nil?
  json.attendance_approval_date ah.attendance_approval_date
end