class TimePeriod::Day < ApplicationRecord
  belongs_to :week
  has_many :searches, class_name: "WorkEnvironment::Search"
  scope :today, -> { where(date: Date.today) }
  scope :yesterday, -> { where(date: Date.yesterday) }
  scope :since_launch, -> { where("date >= ?", "2023-10-30") }
  scope :chronological, -> { order(date: :asc) }
  scope :reverse_chronological, -> { order(date: :desc) }
  scope :last_two_weeks, -> { where("date >= ?", 2.weeks.ago) }

  enum ingestion_status: {
    ingestion_pending: 0,
    ingestion_active: 1,
    ingestion_complete: 2,
    ingestion_error: 3,
    ingestion_aborted: 4,
  }

  def ymd
    date.strftime("%Y-%m-%d")
  end

  def documents
    WorkEnvironment::Document.where("document_date = ?", ymd)
  end

  def last_year
    TimePeriod::Day.find_by(date: date.last_year)
  end

  def tomorrow
    TimePeriod::Day.find_by(date: date.tomorrow)
  end
end
