class Admin::WorkEnvironment::DocumentsController < AdminController
  layout "internal"

  def index
    @documents = WorkEnvironment::Document.reverse_chronological.take(64)
  end

  def show
    @document = WorkEnvironment::Document.find(params[:id])
  end

  def notify
    @document = WorkEnvironment::Document.find(params[:id])
    User::NotificationJob.perform_now(@document.document_code, { cascade: true })
    redirect_to "/legacy_admin/work_environment/documents/#{@document.id}"
    flash[:notice] = "job queued"
  end
end
