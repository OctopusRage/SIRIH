require 'httparty'
class GetMovementsDataJob
  @queue = :normal
  BASE_URL = ENV['SERVER_DATA_URL']
  def self.perform
    # Do something later
    registrations = Registration.where(leave_status:false)
    auth = {:username => "ajiugm", :password => "ajiugm"}
    registrations.each do |r|
      res = HTTParty.get("#{BASE_URL}/pendaftaran/perpindahan/nomor/#{r.registration_code}", :basic_auth => auth)
      if res.code >= 200 && res.code < 400
        data = JSON.parse(res.body)
        data.each do |d|
          Movement.create!(
            registration_code: d["noPendaftaran"],
            bed_code: d["bed"]["id"],
            entry_date: d["waktuMasuk"].to_datetime.strftime("%Y/%m/%d %H:%M:%S"),
            leave_date: ((defined? d["waktuKeluar"]).present?)? d["waktuKeluar"].to_datetime.strftime("%Y/%m/%d %H:%M:%S"):nil,
          )
        end
      end
    end
  end
end
