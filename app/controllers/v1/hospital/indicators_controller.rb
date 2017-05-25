class V1::Hospital::IndicatorsController < ApplicationController
  before_action :authorize_user
  def get_stats
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
    leave_patient_count = Registration.where(leave_status: true).where("leave_date BETWEEN ? AND ?", params[:start_date], params[:end_date]).count
    # los = (Float(inpatient_days) / leave_patient_count)
    los = o * day_diff / leave_patient_count
    bto = Float(leave_patient_count) / available_beds
    toi = (available_beds - o) * day_diff / leave_patient_count
    render json: {
      data: {
        bor: '%.2f' % bor,
        los: '%.2f' % los,
        toi: toi.round,
        bto: bto.round,
      }
    }, status: 200
  end
end
