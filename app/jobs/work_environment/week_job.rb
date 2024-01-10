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

    puts "WeekJob: end"
  end
end