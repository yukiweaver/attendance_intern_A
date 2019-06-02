class AddFirstLeavingTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :first_leaving_time, :datetime
  end
end
