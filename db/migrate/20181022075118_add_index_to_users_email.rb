#Active Recordはデータベースのレベルでは一意性を保証していない→データベースレベルでも一意性を強制するだけで解決
#データベース上のemailのカラムにインデックス (index) を追加し、そのインデックスが一意であるようにすれば解決
#このファイルを作成　unique: で一意性を強制
class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true
  end
end
