class Admin::Legal::DocumentsController < AdminController
  layout "internal"

  def index
    @documents = Legal::Document.all
  end

  def update
    @document = Legal::Document.find_by(document_code: params[:id])
    if @document.nil?
      raise ActionController::RoutingError.new("Not Found")
    end
    if @document.update(params[:document].permit(:document_name, :document_code)) then
      redirect_to "/admin/legal/documents/#{@document.document_code}"
      flash[:notice] = "document updated"
    end
  end

  def show
    @document = Legal::Document.find_by(document_code: params[:id])
    if @document.nil?
      raise ActionController::RoutingError.new("Not Found")
    end
  end

  def new
    @document = Legal::Document.new
  end

  def create
    @document = Legal::Document.create(params[:document].permit(:document_name, :document_code))
    if @document.valid? then
      redirect_to "/admin/legal/documents/#{@document.document_code}"
      flash[:notice] = "document created"
    end
  end
end