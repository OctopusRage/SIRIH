class CreateInpatientDayRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :inpatient_day_rooms do |t|
      t.date :period
      t.integer :total
      t.string :room_code

      t.timestamps
    end
    add_index :inpatient_day_rooms, :room_code
  end
end
