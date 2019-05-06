class AddOneMonthChangeToOneMonthAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :one_month_attendances, :one_month_change, :boolean, default: false
  end
end
