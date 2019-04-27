class OneMonthAttendance < ApplicationRecord
  # 月の勤怠申請　状況(なし:0、申請中:1、承認:2、否認:3)
  enum one_month_application_status: { month_nothing: 0, month_applying: 1, month_approval: 2,  month_denial: 3 }
end
