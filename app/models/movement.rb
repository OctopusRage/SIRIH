class Movement < ApplicationRecord
  belongs_to :registration, :primary_key => "registration_code", :foreign_key => "registration_code"
  belongs_to :bed, :primary_key => "bed_code", :foreign_key => "bed_code"
end
