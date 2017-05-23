class AddMovementsStatusDataJob < ApplicationJob
  queue_as :default
  
  def perform()
    new_patient_entry = 1
    moving_patient_entry = 2
    Movement.all.update_all(entry_status: moving_patient_entry)
    movements = Movement.group(:registration_code, :id).order("entry_date asc, id desc")
    movements.each do |m|
      if Movement.find_by(registration_code: m.registration_code, entry_status: new_patient_entry).nil?
        m.update(entry_status: new_patient_entry)
      end
    end
  end
end
