class NotificationEmailPreview < ActionMailer::Preview
  def send_notification_email
    @notification = Notification.new
    @notification.document = Document.new(
      company_name: "EXEMPEL AB",
      document_code: "000000-0000",
      document_date: Date.today,
      document_type: "Komplettering",
    )
    @notification.subscription = Subscription.new(id: "abcdef12345")
    @notification.subscription.user = User.new(name: "Example User")
    NotificationMailer.with(notification: @notification).notification_email
  end
end