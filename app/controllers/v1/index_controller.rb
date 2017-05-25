class V1::IndexController < ApplicationController
  before_action :authorize_user
  def index
    movements = Movement.joins(:registration => :doctor, :bed => [:room, :room_class]).order("movements.entry_date DESC").page(params[:page]).per(25)
    movements = movements.where("doctors.id = ?", params[:doctor_id]) if params[:doctor_id].present?
    movements = movements.where("DATE(entry_date) BETWEEN ? AND ?", params[:start_date], params[:end_date]) if params[:start_date].present? || params[:end_date].present?
    payload = []
    movements.each do |m|
      payload = payload.push({
        entry_date: m.entry_date,
        patient_id: m.registration.patient_id,
        patient_name: m.registration.patient_name,
        room_name: m.bed.room.name,
        class_name: m.bed.room_class.name,
        diagnose: m.registration.diagnose,
        doctor: m.registration.doctor.name
      })
    end
    render json: {
      data: payload
    }, status: 200
  end
end
