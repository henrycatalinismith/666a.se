class WorkEnvironment::SearchJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    puts exception.message
    puts exception.backtrace
    @search.result_error! unless @search.nil?
  end

  def perform(date, options = {})
    day = TimePeriod::Day.find_by(date: date)
    return if day.nil?

    @search =
      day.searches.create(
        result_status: :result_pending,
        page_number: day.next_page_number
      )

    day.increment!(:request_count)
    @search.result_fetching!
    puts @search.url
    uri = URI(@search.url)
    response = Net::HTTP.get_response(uri)
    document = Nokogiri::HTML.parse(response.body)

    hit_count = document.css("[data-dd-search-hits]").first["data-dd-search-hits"]
    @search.hit_count = hit_count
    @search.save

    results = document.css(".document-list__item")

    results.each do |li|
      h4 = li.css(".headline-4")
      span1 = h4.css("span").first
      span2 = h4.css("span").last
      document_code = span1.text.strip
      document_type = span2.text.strip
      company_code = nil

      case_code = document_code.split("-").first

      document = WorkEnvironment::Document.find_by(document_code:)
      if document.nil?
        if !company_code.nil?
          subscription_count =
            User::Subscription.where(
              company_code: document.company_code
            ).count
          notification_status = subscription_count > 0 ? :notification_pending : :notification_needless
        else
          notification_status = :notification_needless
        end

        document = WorkEnvironment::Document.create(
          document_code:,
          document_type:,
          case_code:,
        )

        if options[:notify] and notification_status == :notification_pending
          User::NotificationJob.set(wait: 1.seconds).perform_later(
            document_code,
            options
          )
        end
      end
    end
  end
end
