class NormalizeMovementsDataJob < ApplicationJob
  queue_as :default

  def perform
    movements = Movement.group(:registration_code).order("count_all DESC").count
    movements.each do |m|
      return if m[1] == 1
      counter = 1
      tmp_date = ""
      Movement.where(registration_code: m[0]).order("entry_date desc").each do |m1|
        if (counter == 1)
          tmp_date = m1.entry_date
          counter = counter+1
          next
        end
        m1.update(leave_date: tmp_date)
        tmp_date = m1.entry_date
        counter = counter + 1
      end
      counter = 1
    end 
  end
end
