class PotatoPrice < ApplicationRecord
  scope :day, lambda { |start_of, end_of| where(time: start_of..end_of).order(:time) }
end
