class V1::RecapitulationsController < ApplicationController
  before_action :authorize_user
  def get_patient_entry
    start_date = DateTime.now.to_date
    end_date = DateTime.now.to_date
    if params[:room_id].nil?
      render json: {
        status: 'fail',
        errors: {
          message: "Room ID is required"
        }
      }, status: 422 and return
    end
    if params[:start_date].present?
      start_date = params[:start_date]
      end_date = params[:end_date] if params[:end_date]
      movements = Movement.joins(:registration, :bed => [:room, :room_class]).where("entry_date BETWEEN ? AND ?", start_date, end_date).where("beds.room_code = ?", params[:room_code]).order("entry_date DESC").page(params[:page]).per(params[:limit])
    else
      movements = Movement.joins(:registration, :bed => [:room, :room_class]).where("beds.room_code = ?", params[:room_id]).order("entry_date DESC").page(params[:page]).per(params[:limit])
    end
    new_patient_p = []
    moving_patient_p = []
    new_patient_q = movements.group("movements.registration_code, movements.id").where("movements.entry_status = ?", 1)
    moving_patient_q = movements.group("movements.registration_code, movements.id").where("movements.entry_status = ?", 2)
    new_patient_q.each do |m|
      new_patient_p.push({
        registration_code: m.registration_code,
        patient_name: m.registration.patient_name,
        patient_id: m.registration.patient_id,
        class: m.bed.room_class.name,
        entry_status: m.entry_status,
      })
    end
    moving_patient_q.each do |m|
      moving_from = Movement.where("movements.registration_code = ? AND entry_date < ?", m.registration_code, m.entry_date)
        .order("entry_date desc").first
      moving_patient_p.push({
        registration_code: m.registration_code,
        patient_name: m.registration.patient_name,
        patient_id: m.registration.patient_id,
        class: m.bed.room_class.name,
        entry_status: m.entry_status,
        moving_from: moving_from.bed.room.name,
      })
    end  
    render json: {
      data: {
        room: Bed.find_by(room_code:params[:room_id]).room.name,
        new_patient: new_patient_p,
        moving_patient: moving_patient_p,
      }
    }, status: 200
  end

  def get_patient_out
    start_date = DateTime.now.to_date
    end_date = DateTime.now.to_date
    if params[:room_id].nil?
      render json: {
        status: 'fail',
        errors: {
          message: "room_id is required"
        }
      }, status: 422 and return
    end
    if params[:start_date].present?
      start_date = params[:start_date]
      end_date = params[:end_date] if params[:end_date]
      movements = Movement.joins(:registration, :bed => [:room, :room_class]).where("leave_date BETWEEN ? AND ?", start_date, end_date).where("beds.room_code = ?", params[:room_code]).order("leave_date DESC").page(params[:page]).per(params[:limit])
    else
      movements = Movement.joins(:registration, :bed => [:room, :room_class]).where("beds.room_code = ?", params[:room_id]).order("leave_date DESC").page(params[:page]).per(params[:limit])
    end
    moving_patient_p = []
    leaving_patient_p = []
    moving_patient_q = movements.group("movements.registration_code, movements.id").where("movements.entry_status = ?", 2)
    leaving_patient_q = movements.group("movements.registration_code, movements.id").where("movements.entry_status = ? AND registrations.leave_status = ?", 2, true).having('max(movements.leave_date) >= movements.leave_date')
    moving_patient_q.each do |m|
      moving_from = Movement.where("movements.registration_code = ? AND entry_date < ?", m.registration_code, m.entry_date)
        .order("entry_date desc").first
      moving_patient_p.push({
        registration_code: m.registration.registration_code,
        patient_name: m.registration.patient_name,
        patient_id: m.registration.patient_id,
        class: m.bed.room_class.name,
        entry_status: m.entry_status,
        moving_from: moving_from.bed.room.name
      })
    end
    leaving_patient_q.each do |m|
      leaving_patient_p.push({
        registration_code: m.registration.registration_code,
        patient_name: m.registration.patient_name,
        patient_id: m.registration.patient_id,
        class: m.bed.room_class.name,
        registration_date: m.registration.registration_date,
        leave_reason: m.registration.leave_reason,
        is_leaving: m.registration.leave_status,
        entry_status: m.entry_status,
      })
    end
    render json: {
      data: {
        room: Bed.find_by(room_code:params[:room_id]).room.name,
        moving_patient: moving_patient_p,
        leaving_patient: leaving_patient_p,
      }
    }, status: 200
  end
end
