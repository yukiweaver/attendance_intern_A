class AddFirstBeginningTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :first_beginning_time, :datetime
  end
end
