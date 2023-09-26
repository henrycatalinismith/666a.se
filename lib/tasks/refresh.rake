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
      # search = Search.create(status: :pending)
      # search.parameters.create(name: "FromDate", value: today)
      # search.parameters.create(name: "ToDate", value: today)
      # search.parameters.create(name: "OrganisationNumber", value: subscription.company_code)

      # begin
      #   response = perform_search(search)
      # rescue
      #   search.status = :error
      # end

      # search.hit_count = response.hit_count
      # response.results.each do |result|
      #   search.results.create(
      #     case_name: result[:case_name],
      #     company_code: result[:company_code],
      #     document_code: result[:document_code],
      #     document_date: result[:document_date],
      #     document_type: result[:document_type],
      #   )
      # end
      # search.status = :success
      
    end
  end
end