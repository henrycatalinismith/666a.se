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
    WorkEnvironment::NotificationJob.perform_now(@document.document_code, { cascade: true })
    redirect_to "/admin/work_environment/documents/#{@document.id}"
    flash[:notice] = "job queued"
  end
end
