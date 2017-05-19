class Room < ApplicationRecord
  has_many :bed, :primary_key => "room_code", :foreign_key => "room_code"
end
