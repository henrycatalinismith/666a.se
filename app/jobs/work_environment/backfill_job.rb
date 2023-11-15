class WorkEnvironment::BackfillJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    earliest_day = Period::Day.chronological.first
    
    if earliest_day.ingestion_active? then
      day = earliest_day
    else
      day_before = earliest_day.date - 1.day
      day = Period::Day.create(
        date: date,
        ingestion_status: :ingestion_pending,
      )
      day.ingestion_active!
    end

    if options[:cascade] then
      WorkEnvironment::DayJob.set(wait: 1.seconds).perform_later(day.date, options)
    end
  end
end