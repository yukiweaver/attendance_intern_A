class AddBaseTypeToBases < ActiveRecord::Migration[5.1]
  def change
    add_column :bases, :base_type, :string
  end
end
