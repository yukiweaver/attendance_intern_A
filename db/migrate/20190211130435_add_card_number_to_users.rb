class AddCardNumberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :card_number, :integer
  end
end
