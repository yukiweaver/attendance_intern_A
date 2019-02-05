class DropTableMicroposts < ActiveRecord::Migration[5.1]
  def change
    drop_table :microposts
  end
end
