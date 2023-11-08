class WorkEnvironment::BackfillJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    earliest_day = Period::Day.chronological.first
    
    if earliest_day.ingestion_active? then
      day = earliest_day
    else
      day_before = earliest_day.date - 1.day
      Period::CreateDayJob.perform_now(day_before)
      day = Period::Day.find_by(date: day_before)
      day.ingestion_active!
    end

    if options[:cascade] then
      WorkEnvironment::DayJob.set(wait: 1.seconds).perform_later(day.date, options)
    end
  end
end