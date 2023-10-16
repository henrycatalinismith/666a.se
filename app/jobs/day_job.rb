class DayJob < ApplicationJob
  queue_as :default

  def perform(date, cascade = false)
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
  end
end