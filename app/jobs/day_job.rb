require "time"

class DayJob < ApplicationJob
  queue_as :default

  def perform(date, cascade = false)
    puts "DayJob: begin"

    day = Day.find_by(date:)

    puts day.inspect
    if day.nil? then
      return
    end

    if day.looks_dormant? then
      day.success!
      return
    end

    if cascade then
      SearchJob.perform_later(day.date, cascade)
    end

    if Time.now < Time.parse("19:00") then
      self.class.set(wait: 5.minutes).perform_later(date)
    end

    puts "DayJob: end"
  end
end