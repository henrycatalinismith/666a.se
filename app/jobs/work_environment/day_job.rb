require "time"

class WorkEnvironment::DayJob < ApplicationJob
  queue_as :default

  def perform(date, options = {})
    day = TimePeriod::Day.find_by(date:)

    return if day.nil?

    if not options[:force] and day.looks_dormant?
      day.ingestion_complete!
      return
    end

    day.searches.destroy_all if options[:purge]

    if Time.now < Time.parse("23:00")
      # self
      # .class
      # .set(wait: 30.seconds)
      # .perform_later(date, { **options, force: false, purge: false })
    end

    if options[:cascade]
      WorkEnvironment::SearchJob.perform_later(day.date, options)
    end
  end
end
