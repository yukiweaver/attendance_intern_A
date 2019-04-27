class Attendance < ApplicationRecord
  # 残業申請　申請状況(なし:0、申請中:1、承認:2、否認:3)
  enum application_status: { nothing: 0, applying: 1, approval: 2,  denial: 3 }
  # 勤怠申請　状況
  enum attendance_application_status: { work_nothing: 0, work_applying: 1, work_approval: 2,  work_denial: 3 }

  #勤怠B：userと紐付け。attendanceがuserに所属。
  belongs_to :user
  # validates :scheduled_end_time, presence: true
end
