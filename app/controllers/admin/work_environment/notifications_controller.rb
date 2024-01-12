class Admin::WorkEnvironment::NotificationsController < AdminController
  layout "internal"

  def index
    companies = WorkEnvironment::Subscription.company_subscription.map(&:company_code).uniq
    documents = WorkEnvironment::Document.where(company_code: companies).reverse_chronological.since_launch.where("document_date >= ?", "2023-12-20") 

    @missing = documents.select do |document|
      document.notifications.count == 0
    end

    @filters = [
      :recent,
      :email_error,
    ]

    if params[:filter].present? and @filters.include?(params[:filter].to_sym) then
      @filter = params[:filter].to_sym
    else
      @filter = @filters.first
    end

    if @filter == :recent then
      @notifications = WorkEnvironment::Notification.reverse_chronological.limit(64)
    elsif @filter == :email_error then
      @notifications = WorkEnvironment::Notification.email_error.reverse_chronological.limit(64)
    end
  end

  def show
    @notification = WorkEnvironment::Notification.find(params[:id])
  end

  def send_email
    @notification = WorkEnvironment::Notification.find(params[:id])
    WorkEnvironment::EmailJob.perform_later(@notification.id, options)
    redirect_to "/admin/work_environment/notifications/#{params[:id]}"
    flash[:notice] = "job queued"
  end
end
