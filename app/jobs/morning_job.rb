class MorningJob < ApplicationJob
  queue_as :default

  def perform(date, cascade = false)
    day = Day.find_by(date:)
    if day.nil? then
      day = Day.create(date: Date.today, status: :active)
    end

    if cascade then
      DayJob.set(wait: 1.seconds).perform_later(date, cascade)
    end
  end
end