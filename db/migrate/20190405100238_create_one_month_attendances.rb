class CreateOneMonthAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :one_month_attendances do |t|
      t.integer :application_user_id  #申請するユーザーのid
      t.string :authorizer_user_test  #承認するユーザーの名前
      t.date :application_date  #申請日
      
      t.timestamps
    end
  end
end
