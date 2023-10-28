class WorkEnvironment::SearchJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    puts exception.message
    puts exception.backtrace
    @search.result_error! unless @search.nil?
  end

  def perform(date, options = {})
    day = Day.find_by(date: date)
    if day.nil? then
      return
    end

    @search = day.searches.create(
      result_status: :result_pending,
      page_number: day.next_page_number,
    )

    @search.result_fetching!
    puts @search.url
    uri = URI(@search.url)
    response = Net::HTTP.get_response(uri)
    document = Nokogiri::HTML.parse(response.body)

    hit_count = document.css(".hit-count").text.strip
    headings = document.css("#handling-results thead th").map { |e| e.text.strip }
    rows = document
      .css("#handling-results tbody tr")
      .map { |e| e.css("td").map { |e| e.text.strip } }
      .map { |r| Hash[headings.zip(r)] }

    @search.hit_count = hit_count

    rows.each do |row|
      document_code = row['Handlingsnummer']
      document = WorkEnvironment::Document.find_by(document_code:)
      document_exists = !document.nil?
      document_status = document_exists ? :document_ready : :document_pending
      metadata_status = document_exists ? :metadata_aborted : :metadata_pending
      @search.results.create(
        metadata_status:,
        document_status:,
        document_code:,
        case_name: row['Ärendemening'],
        document_type: row['Handlingstyp'],
        document_date: row['Datum'],
        organisation_name: row['Organisation'],
        metadata: "",
      )
    end

    @search.result_ready!

    if options[:cascade] then
      @search.results.each_with_index do |result, index|
        if result.metadata_pending? then
          WorkEnvironment::ResultJob.set(wait: index.seconds).perform_later(result.document_code, options)
        end
      end
    end
  end
end