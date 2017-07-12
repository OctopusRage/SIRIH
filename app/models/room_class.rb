class RoomClass < ApplicationRecord
    validates :room_class_code, presence: true
    has_many :beds, :primary_key => "room_class_code", :foreign_key => "room_class_code"
end
