class WorkEnvironment::BackfillJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    earliest_day = Day.chronological.first
    
    if earliest_day.ingestion_active? then
      day = earliest_day
    else
      day_before = earliest_day.date - 1.day
      day = Day.create(date: day_before, ingestion_status: :ingestion_active)
    end

    if options[:cascade] then
      DayJob.set(wait: 1.seconds).perform_later(day.date, options)
    end
  end
end