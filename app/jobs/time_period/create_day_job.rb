require "time"

class TimePeriod::CreateDayJob < ApplicationJob
  queue_as :default

  def perform(date, options = {})
    puts "TimePeriod::CreateDayJob: begin"

    day = TimePeriod::Day.find_by(date:)

    if day.nil? then
      day = TimePeriod::Day.create(
        date: date,
        ingestion_status: :ingestion_pending,
      )
    end

    puts "TimePeriod::CreateDayJob: end"
  end
end