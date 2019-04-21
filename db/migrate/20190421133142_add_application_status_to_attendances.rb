class AddApplicationStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :application_status, :integer, default: 0  # 残業申請　（なし、申請中、承認済み）
  end
end
