class WorkEnvironment::NoticeJob < ApplicationJob
  queue_as :default

  def perform(notification_id = nil, options = {})
    users = User::Account.order(created_at: :asc)
    users.each do |user|
      puts user.email
      NoticeMailer.with(user: user).notice_mail.deliver_now
      sleep(1)
    end
  end
end
