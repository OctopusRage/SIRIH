require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'movements.csv'))
csv = CSV.parse(csv_text.gsub(/\r/, ''), :headers => true)
csv.each do |row|
  r = Movement.new
  r.registration_code = row['registration_code']
  r.bed_code = row['bed_code']
  r.entry_date = row['entry_date']
  r.leave_date = row['leave_date']
  r.save
end