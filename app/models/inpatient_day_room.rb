class InpatientDayRoom < ApplicationRecord
  validates_uniqueness_of :period, :scope => :room_code
end
