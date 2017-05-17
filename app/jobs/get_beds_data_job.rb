require 'httparty'
class GetBedsDataJob < ApplicationJob
  queue_as :default

  BASE_URL = 'http://192.168.1.220:43483/api/webresources'
  def perform
    # Do something later
    auth = {:username => "ajiugm", :password => "ajiugm"}
    res = HTTParty.get("#{BASE_URL}/pendaftaran/bed" , :basic_auth => auth)
    if res.code >= 200 && res.code < 400
      data = res.body
      data.each do |d|
        if Bed.find_by(bed_code: d["id"]).nil?
          if (defined? d["kelas"]).present?
            Bed.create(bed_code: d["id"], class_code: d["kelas.id"], room_code: d["ruang.id"])
          end
        end
      end
    end
  end
end
