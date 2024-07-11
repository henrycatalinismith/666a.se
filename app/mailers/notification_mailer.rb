class NotificationMailer < ApplicationMailer
  def notification_email()
    @notification = params[:notification]
    @document = @notification.document
    @target = @notification.subscription.company_subscription? ? @document.company_name : @document.workplace_name
    @user = @notification.subscription.account
    @url = "https://www.av.se/om-oss/diarium-och-allmanna-handlingar/bestall-handlingar/Case/?id=" + @document.case_code
    @unsubscribe_url = "https://666a.se/unsubscribe/#{@notification.subscription.id}"

    headers = {
      "Precedence": :bulk,
      "X-Auto-Response-Suppress": :OOF,
      "Auto-Submitted": :"auto-generated"
    }

    I18n.with_locale(@user.locale) do
      mail(
        to: @user.email,
        subject: t("notification_email.subject"),
        from: '"666a" <henry@666a.se>'
      )
    end
  end
end
