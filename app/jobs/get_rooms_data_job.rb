require 'httparty'
class GetRoomsDataJob < ApplicationJob
  queue_as :default
  BASE_URL = 'http://192.168.1.220:43483/api/webresources'
  def perform
    # Do something later
    auth = {:username => "ajiugm", :password => "ajiugm"}
    res = HTTParty.get("#{BASE_URL}/pendaftaran/ruang", :basic_auth => auth)
    if res.code >= 200 && res.code < 400
      data = res.body
      data.each do |d|
        if Room.find_by(bed_code: d["id"]).nil?
          Room.create(room_code: d["id"], name: d["nama"])
        end
      end
    end
  end
end
