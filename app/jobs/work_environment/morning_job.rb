class WorkEnvironment::MorningJob < ApplicationJob
  queue_as :default

  def perform(date, options = {})
    day = Period::Day.find_by(date:)
    if day.nil? then
      week_code = Date.parse(date).strftime("%Y-W%W")
      week = Period::Week.find_by(week_code: week_code)
      if week.nil? then
        week = Period::Week.create(
          week_code: week_code
        )
        week.save!
      end
      day = Period::Day.create(
        week_id: week.id,
        date: date,
        ingestion_status: :ingestion_pending,
      )
      day.ingestion_active!
    end

    active_days = Period::Day.ingestion_active
    active_days.each_with_index do |day, index|
      if options[:cascade] then
        WorkEnvironment::DayJob.set(wait: index.seconds).perform_later(day.date, options)
      end
    end
  end
end