require "time"

class WorkEnvironment::PeriodScanJob < ApplicationJob
  queue_as :default

  def perform(start, finish)
    puts "PeriodScanJob: begin"

    day = TimePeriod::Day.find_by(date: start)

    puts day.inspect
    if day.nil? then
      return
    end

    while day.date <= Date.parse(finish) do
      WorkEnvironment::SearchJob.set(wait: 1.seconds).perform_later(day.date, {
        cascade: false,
        notify: false,
        force: false,
      })
      sleep 2.seconds
    end

    puts "PeriodScanJob: end"
  end
end