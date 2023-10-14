require "uri"
require "net/http"

class MetadataFetchJob < ApplicationJob
  queue_as :default

  def perform(result_id, document_code)
    puts "DocumentMetadataJob: begin"
    puts "#{document_code}"

    host = "www.av.se"
    path = "/om-oss/sok-i-arbetsmiljoverkets-diarium/"
    query = { id: document_code }.to_query
    url = "https://#{host}#{path}?#{query}"

    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    document = Nokogiri::HTML.parse(response.body)

    dt = document.css("dt").map { |e| e.text.strip }
    dd = document.css("dd").map { |e| e.text.strip }
    metadata = Hash[dt.zip(dd)]

    result = Result.find(result_id)
    metadata.each do |name, value|
      result.metadata.create({ name:, value: })
    end

    puts metadata.inspect

    puts "DocumentMetadataJob: end"
  end
end