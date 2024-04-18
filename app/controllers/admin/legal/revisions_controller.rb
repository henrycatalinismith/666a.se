class Admin::Legal::RevisionsController < AdminController
  layout "internal"

  def edit
    @revision = Legal::Revision.find_by(revision_code: params[:revision_code])
    @document = @revision.document
  end

  def update
    @revision = Legal::Revision.find_by(revision_code: params[:id])
    if @revision.update(
         params[:revision].permit(:revision_name, :revision_code)
       )
      redirect_to "/admin/legal/revisions/#{@revision.revision_code}"
      flash[:notice] = "revision updated"
    end
  end

  def new
    @document = Legal::Document.find_by(document_code: params[:document_code])
    raise ActionController::RoutingError.new("Not Found") if @document.nil?
    @revision = Legal::Revision.new
  end

  def create
    @document =
      Legal::Document.find_by(document_code: params[:revision][:document_code])
    raise ActionController::RoutingError.new("Not Found") if @document.nil?
    @revision =
      @document.revisions.create(
        params[:revision].permit(:revision_name, :revision_code)
      )
    if @revision.valid?
      redirect_to "/admin/legal/revisions/#{@revision.revision_code}"
      flash[:notice] = "revision created"
    end
  end

  def show
    @revision = Legal::Revision.find_by(revision_code: params[:id])
    @document = @revision.document
  end
end
