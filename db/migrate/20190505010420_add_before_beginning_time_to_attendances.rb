class AddBeforeBeginningTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :before_beginning_time, :datetime
  end
end
