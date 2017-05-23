class AddLeaveStatusJob < ApplicationJob
  queue_as :default

  def perform()
    end_patient = 3
    movements = Movement.group(:registration_code, :id).order("entry_date desc, registration_code")
    movements.each do |m|
      if Movement.find_by(registration_code: m.registration_code, entry_status: new_patient_entry).nil?
        m.update(entry_status: end_patient)
      end
    end
  end

end
