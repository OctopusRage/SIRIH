class AddRegistrationsRefToMovements < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :movements, :registrations, :primary_key => "registration_code", :column => "registration_code"
  end
end
