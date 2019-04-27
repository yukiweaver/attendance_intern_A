class Attendance < ApplicationRecord
  # 残業申請　申請状況
  enum application_status: { "なし" => 1, "申請中" => 2, "承認" => 3, "否認" => 4 }
  # 勤怠申請　状況
  enum attendance_application_status: { "なし" => 1, "申請中" => 2, "承認" => 3, "否認" => 4 }

  #勤怠B：userと紐付け。attendanceがuserに所属。
  belongs_to :user
  # validates :scheduled_end_time, presence: true
end
