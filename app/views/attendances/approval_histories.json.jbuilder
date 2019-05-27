json.array! @approval_histories do |ah|
  json.attendance_day ah.attendance_day
  json.before_beginning_time ah.before_beginning_time
  json.before_leaving_time ah.before_leaving_time
  json.beginning_time ah.beginning_time
  json.leaving_time ah.leaving_time
  json.attendance_test User.find(ah.attendance_test).name if not ah.attendance_test.nil?
  json.attendance_approval_date ah.attendance_approval_date
end