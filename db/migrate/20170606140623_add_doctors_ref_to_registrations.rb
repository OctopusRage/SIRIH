class AddDoctorsRefToRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :registrations, :doctors, foreign_key: true
  end
end
