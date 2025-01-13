class NoticeMailer < ApplicationMailer
  def notice_mail()
    @user = params[:user]
    mail(
      to: @user.email,
      subject: t("notice_mailer.subject"),
      from: '"666a" <henry@666a.se>'
    )
  end
end
