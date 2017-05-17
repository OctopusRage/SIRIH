require 'httparty'
class GetRegistrationsDataJob < ApplicationJob
  queue_as :default
  BASE_URL = 'http://192.168.1.220:43483/api/webresources'
  def perform
    # Do something later
    auth = {:username => "ajiugm", :password => "ajiugm"}
    (0..10000).each do |i|
      res = HTTParty.get("#{BASE_URL}/pendaftaran/#{i}", :basic_auth => auth)
      if res.code >= 200 && res.code < 400
        data = res.body
        data.each do |d|
          return if Registration.last_updated.registration_code == d["noPendaftaran"]
          registrationDate = d["tanggalDaftar"][0..10]
          leaveDate = (defined? d["waktuPemulangan"]).present? ? d["waktuPemulangan"].strftime("%Y/%m/%d %H:%M:%S") : nil
          gender = (defined? d["pasien"]["gender"]).present? ? d["pasien"]["gender"] : "Laki-laki"
          diagnosa = ""
          if (defined? d["diagnosa"])
            if d["diagnosa"].length > 0
              diagnosa = d["diagnosa"][0]["nama"]
            end
          end
          if Registration.find_by("registration_code", d["noPendaftaran"]).nil?
            Registration.create(
              registration_code: d["noPendaftaran"],
              patient_id: d["patient_id"],
              patient_name: d["patient_name"],
              gender: gender,
              doctor_name: d["dokter"]["nama"],
              registration_date: registrationDate,
              leave_date: leaveDate,
              leave_status: d["statusPerawatan"]==0 ? false : true,
              leave_reason: (defined? d["deskripsiPemulangan"]).present? ? d["deskripsiPemulangan"]:""
              diagnose: diagnosa
            )
        end
      else
        break
      end
    end
  end
end
