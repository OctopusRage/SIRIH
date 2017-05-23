class AppendDoctorDataJob < ApplicationJob
  queue_as :default

  def perform
    registrations = Registration.all
    registrations.each do |r|
      next if Doctor.find_by(name: r.doctor_name).present?
      Doctor.create(name: r.doctor_name)
    end
  end
end
