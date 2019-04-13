class AddChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change, :boolean, default: false  # 変更
  end
end
