class NotificationEmailPreview < ActionMailer::Preview
  def send_notification_email
    @notification = Notification.new
    @notification.result = Result.new(
      company_name: "EXEMPEL AB",
      document_code: "000000-0000",
      document_date: Date.today,
      document_type: "Komplettering",
    )
    @notification.refresh = Refresh.new
    @notification.refresh.subscription = Subscription.new
    @notification.refresh.subscription.user = User.new(name: "Example User")
    NotificationMailer.with(notification: @notification).notification_email
  end
end