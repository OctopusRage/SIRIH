class Bed < ApplicationRecord
  has_many :movements, :primary_key => "bed_code", :foreign_key => "bed_code"
  belongs_to :room, :primary_key => "room_code", :foreign_key => "room_code"
  belongs_to :room_class, :primary_key => "room_class_code", :foreign_key => "room_class_code"
  def self.last_updated
    order("updated_at DESC").first
  end
end
