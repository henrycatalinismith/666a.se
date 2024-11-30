class WorkEnvironment::MorningJob < ApplicationJob
  queue_as :default

  def perform(date, options = {})
    day = TimePeriod::Day.find_by(date:)
    if day.nil?
      week_code = Date.parse(date).strftime("%Y-W%W")
      week = TimePeriod::Week.find_by(week_code: week_code)
      if week.nil?
        week = TimePeriod::Week.create(week_code: week_code)
        week.save!
      end
      day =
        TimePeriod::Day.create(
          week_id: week.id,
          date: date,
          ingestion_status: :ingestion_pending
        )
      day.ingestion_active!
    end

    if options[:cascade]
      WorkEnvironment::DayJob.perform_later(
        day.date,
        options
      )
    end
  end
end
