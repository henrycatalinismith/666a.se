require "time"

class WorkEnvironment::DayJob < ApplicationJob
  queue_as :default

  def perform(date, options = {})
    puts "DayJob: begin"

    day = TimePeriod::Day.find_by(date:)

    puts day.inspect
    if day.nil? then
      return
    end

    if not options[:force] and day.looks_dormant? then
      day.ingestion_complete!
      return
    end

    if Time.now < Time.parse("23:00") then
      self.class.set(wait: 30.seconds).perform_later(date, {
        **options,
        :force => false,
      })
    end

    if options[:cascade] then
      WorkEnvironment::SearchJob.perform_later(day.date, options)
    end

    puts "DayJob: end"
  end
end