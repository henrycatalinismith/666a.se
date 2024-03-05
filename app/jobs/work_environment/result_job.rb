require "uri"
require "net/http"

class WorkEnvironment::ResultJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    puts exception.message
    puts exception.backtrace
    @result.metadata_error! unless @result.nil?
  end

  def perform(document_code = nil, options = {})
    if document_code.nil?
      @result = WorkEnvironment::Result.metadata_pending.first
    else
      @result = WorkEnvironment::Result.find_by(document_code:)
    end

    return if @result.nil?

    @result.search.day.increment!(:request_count)
    @result.metadata_fetching!
    uri = URI(@result.url)
    response = Net::HTTP.get_response(uri)
    document = Nokogiri::HTML.parse(response.body)
    dt = document.css("dt").map { |e| e.text.strip }
    dd = document.css("dd").map { |e| e.text.strip }
    metadata = Hash[dt.zip(dd)].to_json
    @result.update(metadata:)
    @result.metadata_ready!

    if options[:cascade]
      WorkEnvironment::DocumentJob.set(wait: 1.seconds).perform_later(
        @result.document_code,
        options
      )
    end
  end
end
