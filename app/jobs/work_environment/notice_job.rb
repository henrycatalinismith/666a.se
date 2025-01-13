class WorkEnvironment::NoticeJob < ApplicationJob
  queue_as :default

  def perform(notification_id = nil, options = {})
    users = User::Account.order(created_at: :asc).offset(0).limit(1)
    users.each do |user|
      NoticeMailer.with(user: user).notice_mail.deliver_now
      sleep(1)
    end
  end
end
