class AddLeavingNextDayToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :leaving_next_day, :boolean, default: false
  end
end
