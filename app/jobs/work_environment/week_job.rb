require "time"

class WorkEnvironment::WeekJob < ApplicationJob
  queue_as :default

  def perform(week_code, options = {})
    puts "WeekJob: begin"

    week = Period::Week.find_by(week_code: week_code)

    puts week.inspect
    if week.nil? then
      return
    end

    week.days.each_with_index do |day, index|
      puts index * 3
      WorkEnvironment::DayJob.set(wait: (index * 3).minutes).perform_now(day.date, {
        **options,
        force: true,
      })
    end

    puts "WeekJob: end"
  end
end