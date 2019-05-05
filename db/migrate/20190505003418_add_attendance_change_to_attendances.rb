class AddAttendanceChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :attendance_change, :boolean, default: false  # 勤怠変更承認　変更
  end
end
