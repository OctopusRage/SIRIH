class V1::IndexController < ApplicationController
  before_action :authorize_user
  def index
    movements = Movement.joins(:registration, :bed => [:room, :room_class]).order("created_at DESC").page(params[:page]).per(25)
    payload = []
    movements.each do |m|
      payload = payload.push({
        created_at: m.created_at.to_date,
        patient_id: m.registration.patient_id,
        patient_name: m.registration.patient_name,
        room_name: m.bed.room.name,
        class_name: m.bed.room_class.name,
        diagnose: m.registration.diagnose,
      })
    end
    render json: {
      data: payload
    }, status: 200
  end
end
