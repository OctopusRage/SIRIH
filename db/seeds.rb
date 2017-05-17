# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# require 'csv'

# csv_text = File.read(Rails.root.join('lib', 'seeds', 'registrations.csv'))
# csv = CSV.parse(csv_text.gsub(/\r/, ''), :headers => true)
# csv.each do |row|
#   r = Registration.new
#   r.registration_code = row['registration_code']
#   r.patient_id = row['patient_id']
#   r.patient_name = row['patient_name']
#   r.doctor_name = row['doctor_name']
#   r.gender = row['gender']
#   r.registration_date = row['registration_date']
#   r.leave_date = row['leave_date']
#   r.diagnose = row['diagnose']
#   if row['leave_status'] == 0
#     r.leave_status = false
#   else
#     r.leave_status = true
#   end
#   r.save
# end