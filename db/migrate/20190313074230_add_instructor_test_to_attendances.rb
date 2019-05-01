class AddInstructorTestToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :instructor_test, :integer  # 残業申請　指示者確認
  end
end
