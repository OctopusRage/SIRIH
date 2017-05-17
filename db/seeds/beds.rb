require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'beds.csv'))
csv = CSV.parse(csv_text.gsub(/\r/, ''), :headers => true)
csv.each do |row|
  r = Bed.new
  r.bed_code = row['bed_code']
  r.room_class_code = row['room_class_code']
  r.room_code = row['room_code']
  r.save
end