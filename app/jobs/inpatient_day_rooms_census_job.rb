class InpatientDayRoomsCensusJob
  @queue = :daily

  def perform(first_date = nil, last_date = nil, room_code = nil)
    if first_date.nil? || last_date.nil?
      first_date = Movement.order(:entry_date).first.entry_date.to_date
      last_date = Movement.order(:entry_date).last.entry_date.to_date
    end
    return if InpatientDayRoom.find_by(period: first_date, room_code: room_code).present?
    if room_code.nil?
      Room.all.each do |room|
        append_data(first_date, last_date, room.room_code)
      end
    else
      append_data(first_date, last_date, room_code)
    end  
  end

  def append_data(first_date, last_date, room_code)
    movements = Movement.joins(:bed)
    (first_date..last_date).each do |date|
      total = 0
      patient_in_range_count = movements
        .where("DATE(entry_date) <= ? AND DATE(leave_date) >= ? AND beds.room_code = ?", date, date, room_code).count
      patient_still_stay_count = movements
        .where("DATE(entry_date) = ? AND DATE(leave_date) is NULL AND beds.room_code = ?", date, room_code).count
      total = patient_in_range_count + one_day_patient_count + patient_still_stay_count
      InpatientDayRoom.create(period: date, total: total, room_code: room_code)
    end
  end
end
