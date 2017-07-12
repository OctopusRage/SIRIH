require 'httparty'
class GetRoomClassDataJob
  @queue = :default
  BASE_URL = ENV['SERVER_DATA_URL']
  def self.perform
    # Do something later
    auth = {:username => "ajiugm", :password => "ajiugm"}
    res = HTTParty.get("#{BASE_URL}/pendaftaran/kelas", :basic_auth => auth)
    if res.code >= 200 && res.code < 400
      byebug
      data = JSON.parse(res.body)

      data.each do |d|
        if RoomClass.find_by(room_class_code: d["id"]).nil?
          RoomClass.create(room_class_code: d["id"], name: d["nama"])
        end
      end
    end
  end
end
