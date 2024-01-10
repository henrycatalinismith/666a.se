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

    monday = Date.parse(week_code)
    dates = (monday..(monday + 6.days)).to_a
    orphan_days = Period::Day.where(week_id: nil, date: dates)
    orphan_days.update_all week_id: week.id

    puts "Period::CreateWeekJob: end"
  end
end