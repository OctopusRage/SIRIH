class CreateRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :registrations do |t|
      t.string :registration_id
      t.string :patient_id
      t.string :patient_name
      t.string :doctor_name
      t.string :gender
      t.date :registration_date
      t.date :leave_date, :null => true
      t.string :diagnose, :default => "", :null => true
      t.boolean :leave_status, :default => false

      t.timestamps
    end
    add_index :registrations, :registration_id, unique: true
    add_index :registrations, :patient_id
  end
end
