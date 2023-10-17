class EmailJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    puts exception.message
    puts exception.backtrace
    @notification.email_error! unless @notification.nil?
  end

  def perform(notification_id = nil)
    puts "EmailJob: begin"

    if notification_id.nil? then
      @notification = Notification.email_pending.first
    else
      @notification = Notification.find(notification_id)
    end
    if @notification.nil? then
      return
    end

    NotificationMailer.with(notification: @notification).notification_email.deliver_now

    @notification.email_success!

    puts "EmailJob: end"
  end
end