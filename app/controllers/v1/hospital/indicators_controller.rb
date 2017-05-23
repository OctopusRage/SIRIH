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
    day_diff = (params[:end_date].to_date - params[:start_date].to_date).to_i
    bor = Float(inpatient_days) * 100 / available_beds * day_diff
    render json: {
      data: {
        bor: bor
      }
    }, status: 200
  end
end
