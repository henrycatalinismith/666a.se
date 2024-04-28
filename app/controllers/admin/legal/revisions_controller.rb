class Admin::LabourLaw::RevisionsController < AdminController
  layout "internal"

  def edit
    @revision = LabourLaw::Revision.find_by(revision_code: params[:revision_code])
    @document = @revision.document
  end

  def update
    @revision = LabourLaw::Revision.find_by(revision_code: params[:id])
    if @revision.update(
         params[:revision].permit(:revision_name, :revision_code)
       )
      redirect_to "/admin/labour_law/revisions/#{@revision.revision_code}"
      flash[:notice] = "revision updated"
    end
  end

  def new
    @document = LabourLaw::Document.find_by(document_code: params[:document_code])
    raise ActionController::RoutingError.new("Not Found") if @document.nil?
    @revision = LabourLaw::Revision.new
  end

  def create
    @document =
      LabourLaw::Document.find_by(document_code: params[:revision][:document_code])
    raise ActionController::RoutingError.new("Not Found") if @document.nil?
    @revision =
      @document.revisions.create(
        params[:revision].permit(:revision_name, :revision_code)
      )
    if @revision.valid?
      redirect_to "/admin/labour_law/revisions/#{@revision.revision_code}"
      flash[:notice] = "revision created"
    end
  end

  def show
    @revision = LabourLaw::Revision.find_by(revision_code: params[:id])
    @document = @revision.document
  end
end
