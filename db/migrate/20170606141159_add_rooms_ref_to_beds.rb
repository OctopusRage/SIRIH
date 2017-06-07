class AddRoomsRefToBeds < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :beds, :rooms, :primary_key => "room_code", :column => "room_code"
  end
end
