class AddDoctorInRegistrationJob < ApplicationJob
  queue_as :default

  def perform
    registration = Registration.all
    registration.each do |r|
      doctor = Doctor.find_by(name: r.doctor_name)
      r.update(doctor_id: doctor.id)
    end
  end
end
