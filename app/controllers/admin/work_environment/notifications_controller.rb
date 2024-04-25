class Admin::WorkEnvironment::NotificationsController < AdminController
  layout "internal"

  def index
    companies = User::Subscription.company_subscription.map(&:company_code).uniq
    documents = WorkEnvironment::Document.where(company_code: companies).reverse_chronological.since_launch.where("document_date >= ?", "2023-12-20")

    @missing = documents.select do |document|
      document.notifications.count == 0
    end

    @filters = [
      :recent,
      :email_error,
      :email_pending,
    ]

    if params[:filter].present? and @filters.include?(params[:filter].to_sym) then
      @filter = params[:filter].to_sym
    else
      @filter = @filters.first
    end

    if @filter == :recent then
      @notifications = User::Notification.reverse_chronological.limit(64)
    elsif @filter == :email_error then
      @notifications = User::Notification.email_error.reverse_chronological.limit(64)
    elsif @filter == :email_pending then
      @notifications = User::Notification.email_pending.reverse_chronological.limit(64)
    end
  end

  def show
    @notification = User::Notification.find(params[:id])
  end

  def send_email
    @notification = User::Notification.find(params[:id])
    User::EmailJob.perform_later(@notification.id)
    redirect_to "/admin/work_environment/notifications/#{params[:id]}"
    flash[:notice] = "job queued"
  end
end
