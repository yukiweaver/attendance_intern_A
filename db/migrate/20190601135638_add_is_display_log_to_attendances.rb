class AddIsDisplayLogToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :is_display_log, :boolean, default: false
  end
end
