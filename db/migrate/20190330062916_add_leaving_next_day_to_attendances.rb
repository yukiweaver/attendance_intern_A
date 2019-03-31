class AddLeavingNextDayToAttendances < ActiveRecord::Migration[5.1]
  # 勤怠編集　翌日
  def change
    add_column :attendances, :leaving_next_day, :boolean, default: false
  end
end
