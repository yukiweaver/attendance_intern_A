class AddAttendanceApplicationStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :attendance_application_status, :integer, default: 0  # 勤怠編集 勤怠変更申請状況
  end
end
