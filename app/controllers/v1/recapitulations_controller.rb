class V1::RecapitulationsController < ApplicationController
  before_action :authorize_user
  def get_patient_entry
    start_date = DateTime.now.to_date
    end_date = DateTime.now.to_date
    if params[:start_date].present?
      start_date = params[:start_date]
      end_date = params[:end_date] if params[:end_date]
      movements = Movement.joins(:registration, :bed => [:room, :room_class])
        .where("entry_date BETWEEN ? AND ?", start_date, end_date)
        .order("entry_date DESC").page(params[:page]).per(params[:limit])
    else
      movements = Movement.joins(:registration, :bed => [:room, :room_class])
        .order("entry_date DESC").page(params[:page]).per(params[:limit])
    end
    movements = movements.where("beds.room_code = ?", params[:room_code]) if params[:room_code].present?
    movements = movements.where(entry_status: 1)
    new_patient = []
    movements.each do |m|
      new_patient.push({
        name: m.registration.patient_name,
        gender: m.registration.gender,
        patient_id: m.registration.patient_id,
        class: m.bed.room_class.name,
        entry_date: m.entry_date,
      })
    end
    render json: {
      data: new_patient,
      total: movements.total_count
    }, status: 200
  end

  def get_patient_out
    start_date = DateTime.now.to_date
    end_date = DateTime.now.to_date
    if params[:start_date].present?
      start_date = params[:start_date]
      end_date = params[:end_date] if params[:end_date]
      registrations = Registration.joins(:movements => [:bed => [:room, :room_class]]).where("registrations.leave_date BETWEEN ? AND ?", start_date, end_date).order("entry_date DESC").page(params[:page]).per(params[:limit])
    else
      registrations = Registration.joins(:movements => [:bed => [:room, :room_class]]).order("registrations.leave_date DESC").page(params[:page]).per(params[:limit])
    end
    registrations = registrations.where("beds.room_code = ?", params[:room_code]) if params[:room_code].present?
    registrations = registrations.where(leave_status: 1)
    leave_patient = []
    registrations.each do |r|
      leave_patient.push({
        name: r.patient_name,
        patient_id: r.patient_id,
        class: r.movements.order("movements.entry_date DESC").first.bed.room_class.name,
        leave_reason: r.leave_reason,
        entry_date: r.registration_date,
        leave_date: r.leave_date,
        length_of_stay: (( r.leave_date - r.registration_date).to_i).to_s + " hari"
      })
    end
    render json: {
      data: leave_patient,
      total: registrations.total_count
    }, status: 200
  end
  def get_patient_out_room
    start_date = DateTime.now.to_date
    end_date = DateTime.now.to_date
    if params[:start_date].present?
      start_date = params[:start_date]
      end_date = params[:end_date] if params[:end_date]
      movements = Movement.joins(:registration, :bed => [:room, :room_class]).where("movements.leave_date BETWEEN ? AND ?", start_date, end_date).order("movements.leave_date DESC").page(params[:page]).per(params[:limit])
    else
      movements = Movement.joins(:registration, :bed => [:room, :room_class]).order("movements.leave_date DESC").page(params[:page]).per(params[:limit])
    end
    movements = movements.where("beds.room_code = ?", params[:room_code]) if params[:room_code].present?
    movements = movements.where(entry_status: 2).where("movements.leave_date IS NOT NULL")
    out_patient = []
    movements.each do |m|
      to_room = Movement.where(registration_code: m.registration_code).where("entry_date > ?", m.entry_date)
        .first
      if to_room.nil? 
        to_room = "Keluar RS"
      else
        to_room = to_room.bed.room.name
      end
      
      out_patient.push({
        registration_code: m.registration_code,
        name: m.registration.patient_name,
        patient_id: m.registration.patient_id,
        class: m.bed.room_class.name,
        to_room: to_room,
        leave_date: m.leave_date,
      })
    end
    render json: {
      data: out_patient,
      total: movements.total_count
    }, status: 200
  end
  def get_patient_enter_room
    start_date = DateTime.now.to_date
    end_date = DateTime.now.to_date
    if params[:start_date].present?
      start_date = params[:start_date]
      end_date = params[:end_date] if params[:end_date]
      movements = Movement.joins(:registration, :bed => [:room, :room_class]).where("movements.entry_date BETWEEN ? AND ?", start_date, end_date).order("movements.leave_date DESC").page(params[:page]).per(params[:limit])
    else
      movements = Movement.joins(:registration, :bed => [:room, :room_class]).order("movements.entry_date DESC").page(params[:page]).per(params[:limit])
    end
    movements = movements.where("beds.room_code = ?", params[:room_code]) if params[:room_code].present?
    movements = movements.where(entry_status: 2)
    moving_patient = []
    movements.each do |m|
      from_room = Movement.where(registration_code: m.registration_code).where("entry_date < ?", m.entry_date).order(:entry_date)
        .first.bed.room.name
      moving_patient.push({
        registration_code: m.registration_code,
        name: m.registration.patient_name,
        patient_id: m.registration.patient_id,
        class: m.bed.room_class.name,
        room: m.bed.room.name,
        from_room: from_room,
        entry_date: m.entry_date,
      })
    end
    render json: {
      data: moving_patient,
      total: movements.total_count
    }, status: 200
  end
end
