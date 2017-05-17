class CreateBeds < ActiveRecord::Migration[5.1]
  def change
    create_table :beds do |t|
      t.string :bed_code
      t.string :room_class_code
      t.string :room_code

      t.timestamps
    end
    add_index :beds, :bed_code, unique: true
    add_index :beds, :room_class_code
    add_index :beds, :room_code
  end
end
