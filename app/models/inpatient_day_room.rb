class InpatientDayRoom < ApplicationRecord
  validates_uniqueness_of :period, :scope => :room_code
  validates :period, presence: true
  validates :total, presence: true
end
