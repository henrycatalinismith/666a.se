require "puppeteer-ruby"

namespace :subscriptions do
  desc "Refresh subscriptions"
  task refresh: :environment do
    subscriptions = Subscription.all
    puts "refreshing #{subscriptions.count} subscriptions"

    subscriptions.each do |subscription|
      puts subscription.company_code
      
      ongoing_refreshes = subscription.refreshes.where(status: [:active, :pending])
      if ongoing_refreshes.count > 0 then
        puts "subscription #{subscription.id} already being refreshed"
      end

      # refresh = subscription.refreshes.create(status: :pending)
    end
  end
end