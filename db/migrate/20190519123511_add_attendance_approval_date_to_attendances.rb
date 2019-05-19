class AddAttendanceApprovalDateToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :attendance_approval_date, :date # 勤怠変更　承認日
  end
end
