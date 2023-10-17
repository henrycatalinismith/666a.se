class MorningJob < ApplicationJob
  queue_as :default

  def perform(date, cascade = false)
    day = Day.find_by(date:)
    if day.nil? then
      day = Day.create(date: date, status: :active)
    end

    active_days = Day.active
    active_days.each_with_index do |day, index|
      if cascade then
        DayJob.set(wait: index.seconds).perform_later(day.date, cascade)
      end
    end
  end
end