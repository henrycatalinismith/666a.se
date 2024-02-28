class TimePeriod::Week < ApplicationRecord
  has_many :days

  scope :chronological, -> { order(week_code: :asc) }
  scope :reverse_chronological, -> { order(week_code: :desc) }
  scope :since_launch, -> { where("week_code >= ?", "2023-W44") }
end