class AddDesignateEndTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :designate_end_time, :time
  end
end
