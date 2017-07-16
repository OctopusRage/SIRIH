require 'httparty'
class GetRoomsDataJob
  @queue = :daily
  BASE_URL = ENV['SERVER_DATA_URL']
  def self.perform
    # Do something later
    auth = {:username => "ajiugm", :password => "ajiugm"}
    res = HTTParty.get("#{BASE_URL}/pendaftaran/ruang", :basic_auth => auth)
    if res.code >= 200 && res.code < 400
      data = JSON.parse(res.body)
      data.each do |d|
        if Room.find_by(room_code: d["id"]).nil?
          Room.create(room_code: d["id"], name: d["nama"])
        end
      end
    end
  end
end
