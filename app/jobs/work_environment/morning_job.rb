class WorkEnvironment::MorningJob < ApplicationJob
  queue_as :default

  def perform(date, options = {})
    day = Period::Day.find_by(date:)
    if day.nil? then
      Period::CreateDayJob.perform_now(date)
      day = Period::Day.find_by(date: date)
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