class V1::Reports::PatientsController < ApplicationController
  def index
    registrations = Registration::where('entry_date = ?', params[:date])
    pasien_keluar = registrations.group_by('leave_reason').count
    leave_patient = registrations.where(leave_status: true)
    leave_patient_count = leave_patient.count
    death_patient = leave_patient.where("LOWER(leave_reason) = 'meninggal'")
    death_patient_count = death_patient.count
    death_after_2day = death_patient.where("EXTRACT(day from registrations.leave_date::timestamp - registrations.registration_date::timestamp) > 2")
    death_after_2day_count = death_after_2day.count
    death_before_2day_count = death_patient_count - death_after_2day
    movements = Movement.joins(:registration,  :bed => [:room, :room_class]).where('DATE(entry_date)', params[:date])
    
    render json: {
      pasien_masuk: registration.count,
      pasien_keluar: pasien_keluar,
      mati_krg_48: death_before_2day_count,
      mati_lbh_48: death_after_2day_count,
      jumlah_pasien_keluar: leave_patient_count,
    }
  end
end

