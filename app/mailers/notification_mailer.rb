class NotificationMailer < ApplicationMailer
  def notification_email()
    @notification = params[:notification]
    @document = @notification.document
    @target = @notification.subscription.company_subscription? ? @document.company_name : @document.workplace_name
    @user = @notification.subscription.user
    @url = "https://www.av.se/om-oss/sok-i-arbetsmiljoverkets-diarium/?id=" + @document.document_code
    @unsubscribe_url = "https://666a.se/unsubscribe/#{@notification.subscription.id}"
    I18n.with_locale(@user.locale) do
      mail(
        to: @user.email,
        subject: t("notification_email.subject"),
        from: '"6:6:6a" <henry@666a.se>'
      )
    end
  end
end
