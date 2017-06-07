class AddRoomClassesRefToBeds < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :beds, :room_classes, primary_key: "room_class_code", column: "room_class_code"
  end
end
