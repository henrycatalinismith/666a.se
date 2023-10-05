require "uri"
require "net/http"

class RefreshSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(subscription, date)
    puts "RefreshSubscriptionJob: begin"

    ongoing_refreshes = subscription.refreshes.where(status: [:active, :pending])
    if ongoing_refreshes.count > 0 then
      puts "RefreshSubscriptionJob: duplicate of #{ongoing_refreshes.first.id}"
      return
    end

    refresh = subscription.refreshes.create(status: :pending)

    search = Search.new
    host = "www.av.se"
    path = "/om-oss/sok-i-arbetsmiljoverkets-diarium/"
    query = {
      FromDate: date,
      ToDate: date,
      OrganisationNumber: subscription.company_code,
    }.to_query
    search.url = "https://#{host}#{path}?#{query}"
    search.status = :active
    search.save

    refresh.search = search
    refresh.save

    begin
      uri = URI(search.url)
      response = Net::HTTP.get_response(uri)
      document = Nokogiri::HTML.parse(response.body)
      search.hit_count = document.css(".hit-count").text.strip
      rows = document.css("#handling-results tbody tr")
      rows.each do |row|
        search.results.create(
          case_name: row.css("td:nth-child(2)").text.strip,
          company_code: row.css("td:nth-child(5)").text.strip.split(/\n/)[1].strip,
          company_name: row.css("td:nth-child(5)").text.strip.split(/\n/)[0].strip,
          document_code: row.css("td:nth-child(1)").text.strip,
          document_date: row.css("td:nth-child(4)").text.strip,
          document_type: row.css("td:nth-child(3)").text.strip,
        )
      end
    rescue => error
      search.status = :error
      search.save
      refresh.status = :error
      refresh.save

      puts "RefreshSubscriptionJob: error"
      puts error.message
      return
    end

    search.status = :success
    search.save

    search.results.each do |result|
      user_notifications = subscription.user.notifications
      has_seen_document = user_notifications.any? { |n| n.result.document_code == result.document_code }
      if not has_seen_document then
        result.notifications.create(
          refresh_id: refresh.id
        )
      end
    end

    refresh.status = :success
    refresh.save

    puts "RefreshSubscriptionJob: end"
  end
end
