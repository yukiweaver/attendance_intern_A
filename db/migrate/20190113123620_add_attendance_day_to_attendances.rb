class AddAttendanceDayToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :attendance_day, :date
  end
end
