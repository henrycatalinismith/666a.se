class WorkEnvironment::NoticeJob < ApplicationJob
  queue_as :default

  def perform(notification_id = nil, options = {})
    users = User::Account.order(created_at: :asc).offset(2).limit(100)
    users.each do |user|
      NoticeMailer.with(user: user).notice_mail.deliver_now
    end
  end
end
