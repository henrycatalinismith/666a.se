class WorkEnvironment::SearchJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    puts exception.message
    puts exception.backtrace
    @search.result_error! unless @search.nil?
  end

  def perform(date, options = {})
    page = options[:page] || 1
    day = TimePeriod::Day.find_by(date: date)
    return if day.nil?

    @search =
      day.searches.create(
        result_status: :result_pending,
        page_number: page
      )

    day.increment!(:request_count)
    @search.result_fetching!
    puts "--"
    puts @search.url(page)
    uri = URI(@search.url(page))
    response = Net::HTTP.get_response(uri)
    puts response.code
    document = Nokogiri::HTML.parse(response.body)

    results = document.css(".document-list__item")
    puts results.count

    results.each do |li|
      h4 = li.css(".headline-4")
      span1 = h4.css("span").first
      span2 = h4.css("span").last
      document_type = span2.text.strip

      definitions = {}
      definition_lists = li.css("dl")
      definition_lists.each do |dl|
        dl.css("dt").each do |dt|
          dt_text = dt.text.strip
          dd_text = dt.next_element.text.strip
          definitions[dt_text] = dd_text
        end
      end
      # {
      #   'Handlingsnummer'=>'2023/062714-1',
      #   'Handlingens datum'=>'2023-10-31',
      #   'Ärende'=>'Olycksfall 20230926. Fysiskt våld',
      #   'Ärendets status'=>'Avslutat',
      #   'Företag/organisation'=>'STIFTELSEN ÅRSTA GÅRD',
      #   'Organisationsnummer:'=>'8020177427',
      #   'Handlingens ursprung'=>'Inkommande',
      #   'Ämnesområde'=>'Bedriva inspektion',
      #   'Arbetsställe'=>'STIFTELSEN ÅRSTA GÅRD',
      #   'Arbetsställenummer (CFAR)'=>'31732407'
      # }

      document_code = definitions["Handlingsnummer"]
      document_date = definitions["Handlingens datum"]
      company_code = definitions["Organisationsnummer:"]
      if company_code.present? and company_code.length == 10 then
        company_code = "#{company_code[0..5]}-#{company_code[6..9]}"
      end
      company_name = definitions["Företag/organisation"]
      workplace_name = definitions["Arbetsställe"]
      workplace_code = definitions["Arbetsställenummer (CFAR)"]

      document_direction = definitions["Handlingens ursprung"]
      if document_direction == "Inkommande" then
        document_direction = :document_incoming
      elsif document_direction == "Utgående" then
        document_direction = :document_outgoing
      else
        document_direction = nil
      end

      case_code = document_code.split("-").first
      case_name = definitions["Ärende"]
      case_status = definitions["Ärendets status"]
      if case_status == "Pågående" then
        case_status = :case_ongoing
      elsif case_status == "Avslutat" then
        case_status = :case_concluded
      end

      document = WorkEnvironment::Document.find_by(document_code:)
      if document.nil?
        if !company_code.nil?
          subscription_count =
            User::Subscription.where(company_code:).count
          notification_status = subscription_count > 0 ? :notification_pending : :notification_needless
        else
          notification_status = :notification_needless
        end

        document = WorkEnvironment::Document.create(
          document_code:,
          document_date:,
          document_type:,
          document_direction:,
          case_code:,
          case_name:,
          case_status:,
          workplace_code:,
          workplace_name:,
          company_code:,
          company_name:,
        )

        if options[:notify] and notification_status == :notification_pending
          User::NotificationJob.set(wait: 1.seconds).perform_later(
            document_code,
            options
          )
        else
          puts "Notify #{document_code}"
        end
      end
    end

    if results.count > 0 and options[:cascade]
      WorkEnvironment::SearchJob.set(wait: 10.seconds).perform_later(
        date,
        { **options, page: page + 1 }
      )
    end
  end
end
