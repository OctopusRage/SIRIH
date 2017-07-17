class InpatientDaysCensusJob
  @queue = :daily

  def self.perform(first_date = nil, last_date = nil)
    if first_date.nil? || last_date.nil?
      first_date = Registration.order(:registration_date).last.registration_date.to_date
      last_date = DateTime.now.to_date
    end
    return if InpatientDay.find_by(period: first_date).present?
    (first_date..last_date).each do |date|
      total = 0
      patient_in_range_count = Registration.where("registration_date <= ? AND leave_date > ?", date, date).count
      one_day_patient_count = Registration
        .where("registration_date = ? AND leave_date = ?", date, date).count
      patient_still_stay_count = Registration
        .where("registration_date = ? AND leave_date is NULL", date).count
      total = patient_in_range_count + one_day_patient_count + patient_still_stay_count
      InpatientDay.create(period: date, total: total)
    end
  end
end
