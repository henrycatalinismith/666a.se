class NotificationEmailPreview < ActionMailer::Preview
  def company_subscription
    @notification = Notification.new
    @notification.document = Document.new(
      company_name: "EXEMPEL AB",
      document_code: "000000-0000",
      document_date: Date.today,
      document_type: "Komplettering",
    )
    @notification.subscription = Subscription.new(
      id: "abcdef12345",
      subscription_type: :company_subscription,
     )
    @notification.subscription.user = User.new(name: "Example User")
    NotificationMailer.with(notification: @notification).notification_email
  end

  def workplace_subscription
    @notification = Notification.new
    @notification.document = Document.new(
      workplace_name: "FÖRKSOLAN EXEMPEL",
      document_code: "000000-0000",
      document_date: Date.today,
      document_type: "Komplettering",
    )
    @notification.subscription = Subscription.new(
      id: "abcdef12345",
      subscription_type: :workplace_subscription,
    )
    @notification.subscription.user = User.new(name: "Example User")
    NotificationMailer.with(notification: @notification).notification_email
  end
end