class User::RetryFailedEmailsJob < ApplicationJob
  queue_as :default

  def perform(since = 1.week.ago)
    User::Notification.email_error.where("created_at > ?", since).each_with_index do |notification, index|
      User::EmailJob.set(wait: index.seconds).perform_later(notification.id)
    end
  end
end
