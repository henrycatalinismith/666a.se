class NotificationMailer < ApplicationMailer
  def notification_email()
    @notification = params[:notification]
    @result = @notification.result
    @user = @notification.refresh.subscription.user
    mail(
      to: @user.email,
      subject: "Work Environment Authority document alert: #{@result.document_code}"
    )
  end
end
