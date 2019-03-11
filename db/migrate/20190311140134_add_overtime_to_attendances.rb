class AddOvertimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :scheduled_end_time, :datetime
    add_column :attendances, :next_day, :boolean, default: false
    add_column :attendances, :business_outline, :string
  end
end
