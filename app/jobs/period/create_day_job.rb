require "time"

class Period::CreateDayJob < ApplicationJob
  queue_as :default

  def perform(date, options = {})
    puts "Period::CreateDayJob: begin"

    day = Period::Day.find_by(date:)

    if day.nil? then
      day = Period::Day.create(date: date)
    end

    puts "Period::CreateDayJob: end"
  end
end