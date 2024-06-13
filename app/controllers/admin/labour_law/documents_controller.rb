class Admin::LabourLaw::DocumentsController < AdminController
  layout "internal"

  def index
    @documents = LabourLaw::Document.all
  end

  def show
    @document = LabourLaw::Document.find(params[:id])
    if @document.nil?
      raise ActionController::RoutingError.new("Not Found")
    end
  end

  def edit
    @document = LabourLaw::Document.find(params[:id])
  end

  def update
    @document = LabourLaw::Document.find(params[:id])
    if @document.nil?
      raise ActionController::RoutingError.new("Not Found")
    end
    if @document.update(params[:document].permit(
      :document_name,
      :document_code,
      :document_slug,
      )) then
      redirect_to admin_labour_law_document_path(@document)
      flash[:notice] = "document updated"
    end
  end

  def new
    @document = LabourLaw::Document.new
  end

  def create
    @document = LabourLaw::Document.create(params[:document].permit(
      :document_name,
      :document_code,
      :document_slug,
    ))
    if @document.valid? then
      redirect_to "/legacy_admin/labour_law/documents/#{@document.id}"
      flash[:notice] = "document created"
    end
  end

  def destroy
    @document = LabourLaw::Document.find(params[:id])
    if @document.destroy then
      redirect_to admin_labour_law_documents_path
      flash[:notice] = "document deleted"
    end
  end
end
