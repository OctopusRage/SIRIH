class InpatientDay < ApplicationRecord
  validates :period, presence: true
  validates :total, presence: true
end