class WorkEnvironment::BackfillJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    earliest_day = Period::Day.chronological.first
    
    if earliest_day.ingestion_active? then
      day = earliest_day
    else
      day_before = earliest_day.date - 1.day
      week_code = day_before.strftime("%Y-W%W")
      week = Period::Week.find_by(week_code: week_code)
      if week.nil? then
        week = Period::Week.create(
          week_code: week_code
        )
        week.save!
      end
      day = Period::Day.create(
        week_id: week.id,
        date: day_before,
        ingestion_status: :ingestion_pending,
      )
      day.ingestion_active!
    end

    if options[:cascade] then
      WorkEnvironment::DayJob.set(wait: 1.seconds).perform_later(day.date, options)
    end
  end
end