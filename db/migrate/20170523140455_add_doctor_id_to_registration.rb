class AddDoctorIdToRegistration < ActiveRecord::Migration[5.1]
  def change
    add_column :registrations, :doctor_id, :integer, :null => true
    add_index :registrations, :doctor_id
  end
end
