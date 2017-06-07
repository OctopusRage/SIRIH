class V1::GbjController < ApplicationController 
  def index
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
    available_beds = Bed.count
    inpatient_days = InpatientDay.where("period BETWEEN ? AND ?", params[:start_date], params[:end_date]).sum(:total)
    day_diff = (params[:end_date].to_date - params[:start_date].to_date).to_i + 1
    o = Float(inpatient_days) / day_diff
    bor = o * 100 / available_beds
    leave_patient = Registration.where(leave_status: true).where("leave_date BETWEEN ? AND ?", params[:start_date], params[:end_date])
    death_patient = leave_patient.where("LOWER(leave_reason) = 'meninggal'")
    death_patient_count = death_patient.count
    death_after_2day = death_patient.where("EXTRACT(day from registrations.leave_date::timestamp - registrations.registration_date::timestamp) > 2")
    death_after_2day_count = death_after_2day.count
    leave_patient_count = leave_patient.count
    # los = (Float(inpatient_days) / leave_patient_count)
    los = bor/10
    bto = Float(leave_patient_count) / available_beds
    toi = 10 - los
    gdr = Float(death_patient_count) * 1000 / leave_patient_count
    ndr = Float(death_after_2day_count) * 1000 / leave_patient_count
    bto_xy = day_diff /bto
    m1 = -1
    m2 = los / toi
    c1 = bto_xy
    c2 = 0
    x = (c2 -c1) / (m1-m2)
    y = (m1 * c2 - m2 * c1) / (m1-m2)
    render json: {
      data: {
        m1: m1, 
        m2: m2, 
        bor: bor.round(2),
        los: los.round(2),
        toi: toi.round(2),
        bto: bto.round,
        bto_xy: bto_xy,
        gdr: gdr.round(2),
        ndr: ndr.round(2),
        hp: inpatient_days,
        intersection_point: {
          x: x,
          y: y,
        }
      }
    }, status: 200
  end
end
