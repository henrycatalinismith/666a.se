require "time"

class Period::CreateWeekJob < ApplicationJob
  queue_as :default

  def perform(week_code, options = {})
    puts "Period::CreateWeekJob: begin"

    week = Period::Week.find_by(week_code:)

    if week.nil? then
      week = Period::Week.create(
        week_code: week_code,
      )
    end

    puts "Period::CreateWeekJob: end"
  end
end