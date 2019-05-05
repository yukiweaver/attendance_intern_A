class AddBeforeLeavingTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :before_leaving_time, :datetime
  end
end
