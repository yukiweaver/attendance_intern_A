class OneMonthAttendance < ApplicationRecord
  # 月の勤怠申請　状況
  enum one_month_application_status: { "なし" => 1, "申請中" => 2, "承認" => 3, "否認" => 4 }
end
