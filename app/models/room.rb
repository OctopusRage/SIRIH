class Room < ApplicationRecord
  has_many :beds, :primary_key => "room_code", :foreign_key => "room_code"
end
