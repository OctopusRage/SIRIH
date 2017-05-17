class Registration < ApplicationRecord
  def self.last_updated
    order("updated_at DESC").first
  end
end
