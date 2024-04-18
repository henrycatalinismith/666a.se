require "time"

class TimePeriod::CreateDayJob < ApplicationJob
  queue_as :default

  def perform(date, options = {})
    day = TimePeriod::Day.find_by(date:)

    if day.nil?
      day =
        TimePeriod::Day.create(date: date, ingestion_status: :ingestion_pending)
    end
  end
end
