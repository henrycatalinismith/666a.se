require "time"

class Period::CreateDayJob < ApplicationJob
  queue_as :default

  def perform(date, options = {})
    puts "Period::CreateDayJob: begin"

    day = Period::Day.find_by(date:)

    if day.nil? then
      day = Period::Day.create(
        date: date,
        ingestion_status: :ingestion_pending,
      )
    end

    puts "Period::CreateDayJob: end"
  end
end