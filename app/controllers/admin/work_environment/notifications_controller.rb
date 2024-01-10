class Admin::WorkEnvironment::NotificationsController < AdminController
  layout "internal"

  def index
    companies = WorkEnvironment::Subscription.company_subscription.map(&:company_code).uniq
    documents = WorkEnvironment::Document.where(company_code: companies).reverse_chronological.since_launch.where("document_date >= ?", "2023-12-20") 

    @missing = documents.select do |document|
      document.notifications.count == 0
    end
  end
end
