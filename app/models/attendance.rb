class Attendance < ApplicationRecord
  #勤怠B：userと紐付け。attendanceがuserに所属。
  belongs_to :user
  # validates :scheduled_end_time, presence: true
end
