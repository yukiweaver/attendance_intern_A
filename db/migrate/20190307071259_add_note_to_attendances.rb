class AddNoteToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :note, :string
  end
end
