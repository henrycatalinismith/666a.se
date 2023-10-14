require "uri"
require "net/http"

class DocumentMetadataJob < ApplicationJob
  queue_as :default

  def perform(document_code)
    puts "DocumentMetadataJob: begin"
    puts "#{document_code}"

    host = "www.av.se"
    path = "/om-oss/sok-i-arbetsmiljoverkets-diarium/"
    query = { id: document_code }.to_query
    url = "https://#{host}#{path}?#{query}"

    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    document = Nokogiri::HTML.parse(response.body)

    dd = document.css("dd").map { |e| e.text.strip }

    puts dd.inspect

    puts "DocumentMetadataJob: end"
  end
end