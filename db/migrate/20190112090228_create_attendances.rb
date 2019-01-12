class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.datetime :beginning_time
      t.datetime :leaving_time

      t.timestamps
    end
  end
end
