class User::EmailJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    @notification.email_error! unless @notification.nil?
  end

  def perform(notification_id = nil, options = {})
    if notification_id.nil?
      @notification = User::Notification.email_pending.first
    else
      @notification = User::Notification.find(notification_id)
    end
    return if @notification.nil?

    NotificationMailer
      .with(notification: @notification)
      .notification_email
      .deliver_now

    @notification.email_success!
  end
end
