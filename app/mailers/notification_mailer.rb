class NotificationMailer < ApplicationMailer
  def notification_email()
    @notification = params[:notification]
    @document = @notification.document
    @user = @notification.subscription.user
    @url = "https://www.av.se/om-oss/sok-i-arbetsmiljoverkets-diarium/?id=" + @document.document_code
    I18n.with_locale(@user.locale) do
      mail(
        to: @user.email,
        subject: t("notification_email.subject"),
        from: "666a <hen@666a.se>"
      )
    end
  end
end
