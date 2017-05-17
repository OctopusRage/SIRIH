class CreateMovements < ActiveRecord::Migration[5.1]
  def change
    create_table :movements do |t|
      t.string :registration_id
      t.string :bed_id
      t.date :entry_date
      t.date :leave_date, :null => true

      t.timestamps
    end
    add_index :movements, :registration_id
    add_index :movements, :bed_id
  end
end
