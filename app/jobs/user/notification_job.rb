require "uri"
require "net/http"

class User::NotificationJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    puts exception.message
    puts exception.backtrace
    @document.notification_error! unless @document.nil?
  end

  def perform(document_code, options = {})
    @document = WorkEnvironment::Document.find_by(document_code:)
    return if @document.nil?

    subscriptions =
      User::Subscription.where(company_code: @document.company_code)
    notifications = []
    subscriptions.each do |subscription|
      if !subscription.has_notification?(@document.id)
        notifications << User::Notification.create(
          email_status: :email_pending,
          subscription_id: subscription.id,
          document_id: @document.id
        )
      end
    end

    @document.notification_success!

    if options[:cascade]
      notifications.each_with_index do |notification, index|
        User::EmailJob.set(wait: index.seconds).perform_later(
          notification.id,
          options
        )
      end
    end
  end
end
