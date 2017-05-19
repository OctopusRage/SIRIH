class Registration < ApplicationRecord
  has_many :movements, :primary_key => "registration_code", :foreign_key => "registration_code"
  
  def self.last_updated
    order("updated_at DESC").first
  end
end
