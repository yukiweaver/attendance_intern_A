#勤怠：所属のマイグレーション
class AddBelongToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :belong, :string
  end
end
