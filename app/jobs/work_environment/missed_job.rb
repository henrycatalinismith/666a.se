class WorkEnvironment::MissedJob < ApplicationJob
  queue_as :default

  def perform()
    companies = WorkEnvironment::Subscription.company_subscription.map(&:company_code).uniq
    documents = WorkEnvironment::Document.where(company_code: companies).chronological.since_launch.where("document_date >= ?", "2023-12-20") 

    missing = documents.select do |document|
      document.notifications.count == 0
    end

    if missing.empty? then
      return
    end

    missing.update_all(notification_status: :notification_pending)
  end
end