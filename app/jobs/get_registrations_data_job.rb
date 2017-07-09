require 'httparty'
class GetRegistrationsDataJob
  @queue = :normal
  BASE_URL = ENV['SERVER_DATA_URL']
  def self.perform
    auth = {:username => "ajiugm", :password => "ajiugm"}
    last_updated = Registration.last_updated
    (1..10000).each do |ci|
      res = HTTParty.get("#{BASE_URL}/pendaftaran/#{ci}", :basic_auth => auth)
      if res.code >= 200 && res.code < 400
        data = JSON.parse(res.body)
        data.each do |d|
          return if last_updated.registration_code == d["noPendaftaran"] && last_updated.updated_at == d["terakhirUpdate"]
          registrationDate = d["tanggalDaftar"][0..10]
          leaveDate = (defined? d["waktuPemulangan"]).present? ? d["waktuPemulangan"].to_datetime.strftime("%Y/%m/%d %H:%M:%S") : nil
          gender = (defined? d["pasien"]["gender"]).present? ? d["pasien"]["gender"] : "Laki-laki"
          diagnosa = ""
          if (defined? d["diagnosa"])
            if d["diagnosa"].length > 0
              diagnosa = d["diagnosa"][0]["nama"]
            end
          end
          doctor_name = ""
          doctor = Doctor.find_by(name: d["dokter"]["nama"])
          if doctor.nil?
            Doctor.create!(
              name: d["dokter"]["nama"]
            )
          end
          registration = Registration.find_by(registration_code: d["noPendaftaran"])
          if registration.nil?
            a = Registration.create!(
              registration_code: d["noPendaftaran"],
              patient_id: d["pasien"]["noRm"],
              patient_name: d["pasien"]["nama"],
              gender: gender,
              doctor_name: d["dokter"]["nama"],
              registration_date: registrationDate,
              leave_date: leaveDate,
              doctor_id: doctor.id,
              leave_status: d["statusPerawatan"]==0 ? false : true,
              leave_reason: ((defined? d["deskripsiPemulangan"]).present?) ? d["deskripsiPemulangan"]:"",
              updated_at: d["terakhirUpdate"],
              diagnose: diagnosa
            )
          else
            if registration.leave_status != d["leave_status"]
              registration.update(
                leave_status: d["leave_status"],
                leave_reason: d["leave_reason"],
                diagnose: d["diagnosa"]
              )
            end
          end
        end
      else
        break
      end
    end
  end
end
