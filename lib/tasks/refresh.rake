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

      date = "2023-08-30"
      refresh = subscription.refreshes.create(status: :pending)

      search = refresh.searches.create(status: :pending)
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

      begin
        Puppeteer.launch(headless: true) do |browser|
          page = browser.new_page
          page.goto search.url, wait_until: 'domcontentloaded'
          search.hit_count = page.eval_on_selector(".hit-count", "e => e.innerText")
          page.query_selector_all("#handling-results tbody tr").each do |row|
            search.results.create(
              case_name: row.eval_on_selector("td:nth-child(2)", "e => e.innerText"),
              company_code: row.eval_on_selector("td:nth-child(5)", "e => e.innerText").split(/\n/)[1],
              company_name: row.eval_on_selector("td:nth-child(5)", "e => e.innerText").split(/\n/)[0],
              document_code: row.eval_on_selector("td:nth-child(1)", "e => e.innerText"),
              document_type: row.eval_on_selector("td:nth-child(3)", "e => e.innerText"),
              document_date: row.eval_on_selector("td:nth-child(4)", "e => e.innerText"),
            )
          end
        end
      rescue
        search.status = :error
        search.save
        refresh.status = :error
        refresh.save
      end

      search.status = :success
      search.save

      search.results.each do |result|
        result.notifications.create(
          refresh_id: refresh.id
        )
      end

      refresh.status = :success
      refresh.save
      
    end
  end
end