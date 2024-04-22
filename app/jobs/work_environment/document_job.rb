require "uri"
require "net/http"

class WorkEnvironment::DocumentJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    @result.document_error! unless @result.nil?
  end

  def perform(document_code = nil, options = {})
    if document_code.nil?
      @result = WorkEnvironment::Result.metadata_ready.document_pending.first
    else
      @result = WorkEnvironment::Result.find_by(document_code:)
    end
    return if @result.nil?

    @result.document_active!
    document =
      WorkEnvironment::Document.find_by(document_code: @result.document_code)
    if !document.nil?
      @result.document_ready!
      return
    end

    document = @result.to_document

    if !document.company_code.nil?
      subscription_count =
        User::Subscription.where(
          company_code: document.company_code
        ).count
      notification_status = subscription_count > 0 ? :notification_pending : :notification_needless
    else
      notification_status = :notification_needless
    end

    document.save
    @result.document_ready!

    if options[:notify] and notification_status == :notification_pending
      User::NotificationJob.set(wait: 1.seconds).perform_later(
        document_code,
        options
      )
    end
  end
end
