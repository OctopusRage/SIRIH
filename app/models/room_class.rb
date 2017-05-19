class RoomClass < ApplicationRecord
    has_many :beds, :primary_key => "room_class_code", :foreign_key => "room_class_code"
end
