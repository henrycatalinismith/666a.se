class DailyRefreshJob < ApplicationJob
  queue_as :default

  def perform(date)
    puts "DailyRefreshJob: begin"
    subscriptions = Subscription.all
    puts "DailyRefreshJob: #{subscriptions.count}"
    subscriptions.each_with_index do |subscription, i|
      RefreshSubscriptionJob.perform_later(subscription, date)
    end
    puts "DailyRefreshJob: end"
  end
end