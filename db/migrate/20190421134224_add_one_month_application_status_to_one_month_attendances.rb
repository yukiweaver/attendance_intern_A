class AddOneMonthApplicationStatusToOneMonthAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :one_month_attendances, :one_month_application_status, :integer, default: 0  # 月の勤怠申請　申請状況
  end
end
