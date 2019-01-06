class AddDesignateWorkTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :designate_work_time, :time
  end
end
