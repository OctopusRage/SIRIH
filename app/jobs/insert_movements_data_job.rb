require 'httparty'
class GetMovementsDataJob < ApplicationJob
  @queue = :normal
  BASE_URL = ENV['SERVER_DATA_URL']
  def self.perform
    # Do something later
    auth = {:username => "ajiugm", :password => "ajiugm"}
    [0..10000].each do |i|
      res = HTTParty.get("#{BASE_URL}/perpindahan/#{i}", :basic_auth => auth)
      if res.code >= 200 && res.code < 400
        data = JSON.parse(res.body)
        data.each do |d|
          return if Movement.last.registration_code == d["noPendaftaran"]
          Movement.create(
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
