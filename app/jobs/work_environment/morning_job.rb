class WorkEnvironment::MorningJob < ApplicationJob
  queue_as :default

  def perform(date, options = {})
    day = Day.find_by(date:)
    if day.nil? then
      day = Day.create(date: date, ingestion_status: :ingestion_active)
    end

    active_days = Day.ingestion_active
    active_days.each_with_index do |day, index|
      if options[:cascade] then
        DayJob.set(wait: index.seconds).perform_later(day.date, options)
      end
    end
  end
end