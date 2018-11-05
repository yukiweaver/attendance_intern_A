#リスト 10.54: boolean型のadmin属性をUserに追加するマイグレーション
class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
