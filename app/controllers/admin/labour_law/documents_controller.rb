class Admin::LabourLaw::DocumentsController < AdminController
  layout "internal"

  def index
    @documents = LabourLaw::Document.all
  end

  def update
    @document = LabourLaw::Document.find_by(document_code: params[:id])
    if @document.nil?
      raise ActionController::RoutingError.new("Not Found")
    end
    if @document.update(params[:document].permit(:document_name, :document_code)) then
      redirect_to "/admin/labour_law/documents/#{@document.document_code}"
      flash[:notice] = "document updated"
    end
  end

  def show
    @document = LabourLaw::Document.find_by(document_code: params[:id])
    if @document.nil?
      raise ActionController::RoutingError.new("Not Found")
    end
  end

  def new
    @document = LabourLaw::Document.new
  end

  def create
    @document = LabourLaw::Document.create(params[:document].permit(:document_name, :document_code))
    if @document.valid? then
      redirect_to "/admin/labour_law/documents/#{@document.document_code}"
      flash[:notice] = "document created"
    end
  end
end
