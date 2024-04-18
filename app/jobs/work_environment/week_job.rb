require "time"

class WorkEnvironment::WeekJob < ApplicationJob
  queue_as :default

  def perform(week_code, options = {})
    week = TimePeriod::Week.find_by(week_code: week_code)

    return if week.nil?

    week.days.each_with_index do |day, index|
      WorkEnvironment::DayJob.set(wait: (index * 3).minutes).perform_now(
        day.date,
        { **options, force: true }
      )
    end
  end
end
