class RoomClass < ApplicationRecord
    has_many :bed, :primary_key => "room_class_code", :foreign_key => "room_class_code"
end
