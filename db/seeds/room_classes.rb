require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'classes.csv'))
csv = CSV.parse(csv_text.gsub(/\r/, ''), :headers => true)
csv.each do |row|
  r = RoomClass.new
  r.room_class_code = row['room_class_code']
  r.name = row['name']
  r.save
end