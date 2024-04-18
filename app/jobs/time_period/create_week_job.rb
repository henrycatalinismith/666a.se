require "time"

class TimePeriod::CreateWeekJob < ApplicationJob
  queue_as :default

  def perform(week_code, options = {})
    week = TimePeriod::Week.find_by(week_code:)

    week = TimePeriod::Week.create(week_code: week_code) if week.nil?

    monday = Date.parse(week_code)
    dates = (monday..(monday + 6.days)).to_a
    orphan_days = TimePeriod::Day.where(week_id: nil, date: dates)
    orphan_days.update_all week_id: week.id
  end
end
