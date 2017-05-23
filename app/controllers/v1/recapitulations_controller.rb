class V1::RecapitulationsController < ApplicationController
  def get_patient_entry
    start_date = DateTime.now.to_date
    end_date = DateTime.now.to_date
    if params[:room_id].nil?
      render json: {Dari backend udah ready ya mas, tinggal dari frontend nya
        status: 'fail',
        errors: {
          message: "Room ID is required"
        }
      }, status: 422 and return
    end
    if params[:start_date].present?
      start_date = params[:start_date]
      end_date = params[:end_date] if params[:end_date]
      movements = Movement.joins(:registration, :bed => [:room, :room_class]).where("entry_date BETWEEN ? AND ?", start_date, end_date).where("beds.room_code = ?", params[:room_code]).order("entry_date DESC").page(params[:page]).per(25)
    else
      movements = Movement.joins(:registration, :bed => [:room, :room_class]).where("beds.room_code = ?", params[:room_id]).order("entry_date DESC").page(params[:page]).per(25)
    end
    new_patient_p = []
    moving_patients_p = []
    new_patient_q = movements.group("movements.registration_code, movements.id").having("count(movements.id) = 1")
    new_patient_q.each do |m|
      new_patient_p.push({
        registration_code: m.registration.registration_code,
        patient_name: m.registration.patient_name,
        patient_id: m.registration.patient_id,
        class: m.bed.room_class.name,
      })
    end
    
    render json: {
      data: new_patient_p
    }, status: 200
  end
end
