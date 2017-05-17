class CreateRoomClasses < ActiveRecord::Migration[5.1]
  def change
    create_table :room_classes do |t|
      t.string :room_class_code
      t.string :name

      t.timestamps
    end
    add_index :room_classes, :room_class_code, unique: true
  end
end
