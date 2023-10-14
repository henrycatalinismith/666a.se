class DayCreateJob < ApplicationJob
  queue_as :default

  def perform(date)
    Day.create(date: Date.today)
  end
end