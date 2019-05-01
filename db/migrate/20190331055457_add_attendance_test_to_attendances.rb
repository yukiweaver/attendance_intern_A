class AddAttendanceTestToAttendances < ActiveRecord::Migration[5.1]
  # 勤怠編集　指示者確認
  def change
    add_column :attendances, :attendance_test, :integer
  end
end
