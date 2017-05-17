class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :room_code
      t.string :name

      t.timestamps
    end
    add_index :rooms, :room_code, unique: true
  end
end
