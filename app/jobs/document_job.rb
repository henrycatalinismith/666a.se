require "uri"
require "net/http"

class DocumentJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    puts exception.message
    puts exception.backtrace
    @result.document_error! unless @result.nil?
  end

  def perform(document_code = nil, cascade = false)
    puts "DocumentJob: begin"

    if document_code.nil? then
      @result = Result.metadata_ready.document_pending.first
    else
      @result = Result.find_by(document_code:)
    end
    if @result.nil? then
      return
    end

    @result.document_active!
    document = Document.find_by(document_code: @result.document_code)
    if !document.nil? then
      @result.document_ready!
      return
    end

    document = @result.to_document
    document.save
    @result.document_ready!

    puts "DocumentJob: end"
  end
end