require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'rooms.csv'))
csv = CSV.parse(csv_text.gsub(/\r/, ''), :headers => true)
csv.each do |row|
  r = Room.new
  r.room_code = row['room_code']
  r.name = row['name']
  r.save
end