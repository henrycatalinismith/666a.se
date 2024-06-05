class NoticeMailer < ApplicationMailer
  def notice_mail()
    @user = params[:user]
    mail(
      to: @user.email,
      subject: "666a email alerts are temporarily offline",
      from: '"666a" <henry@666a.se>'
    )
  end
end
