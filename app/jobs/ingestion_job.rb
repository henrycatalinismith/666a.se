class IngestionJob < ApplicationJob
  queue_as :default

  def perform(cascade = false)
    today = Day.today.first
    if today.nil? then
      today = Day.create(date: Date.today, status: :active)
    end

    active_days = Day.active
    puts active_days.inspect
    puts cascade.inspect
    active_days.each do |day|
      if cascade then
        DayJob.perform_later(day.date.strftime("%Y-%m-%d"), cascade)
      end
    end
  end
end