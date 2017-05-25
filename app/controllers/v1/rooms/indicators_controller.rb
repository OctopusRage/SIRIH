class V1::Rooms::IndicatorsController < ApplicationController
  before_action :authorize_user
  def index
    if params[:room_code].nil?
      render json: {
        status: 'fail',
        errors: {
          message: 'room_code is required'
        }
      }, status: 422 and return
    end
    if params[:start_date].nil? || params[:end_date].nil?
      render json: {
        status: 'fail',
        errors: {
          message: 'start_date or end_date are required'
        }
      }, status: 422 and return
    end
    if params[:start_date] > params[:end_date] 
      render json: {
        status: 'fail',
        errors: {
          message: 'start_date must less than end_date'
        }
      }, status: 422 and return
    end
    available_beds = Bed.joins(:room).where(room_code: params[:room_code]).count
    inpatient_days = InpatientDayRoom.where(room_code: params[:room_code]).where("period BETWEEN ? AND ?", params[:start_date], params[:end_date]).sum(:total)
    day_diff = (params[:end_date].to_date - params[:start_date].to_date).to_i + 1
    o = Float(inpatient_days) / day_diff
    bor = o * 100 / available_beds 
    registrations = Registration.joins(:movements => :bed).where("beds.room_code = ?", params[:room_code])
    leave_room = registrations.where("DATE(movements.leave_date) BETWEEN ? AND ?", params[:start_date], params[:end_date])
    leave_patient = registrations.where(leave_status: true).where("movements.leave_date BETWEEN ? AND ?", params[:start_date], params[:end_date])
    death_patient = leave_patient.where("LOWER(leave_reason) = 'meninggal'")
    death_patient_count = death_patient.count
    death_after_2day = death_patient.where("EXTRACT(day from registrations.leave_date::timestamp - registrations.registration_date::timestamp) > 2")
    death_after_2day_count = death_after_2day.count
    leave_patient_count = leave_room.count
    # los = (Float(inpatient_days) / leave_patient_count)
    los = o * day_diff / leave_patient_count
    bto = Float(leave_patient_count) / available_beds
    toi = (available_beds - o) * day_diff / leave_patient_count
    gdr = Float(death_patient_count) * 1000 / leave_patient_count
    ndr = Float(death_after_2day_count) * 1000 / leave_patient_count
    render json: {
      data: {
        bor: bor.round(2),
        los: los.round(2),
        toi: toi.round,
        bto: bto.round,
        gdr: gdr.round(2),
        ndr: ndr.round(2),
      }
    }, status: 200
  end
end
