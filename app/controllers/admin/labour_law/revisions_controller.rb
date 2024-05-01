class Admin::LabourLaw::RevisionsController < AdminController
  layout "internal"

  def edit
    @revision = LabourLaw::Revision.find_by(revision_code: params[:revision_code])
    @document = @revision.document
  end

  def update
    @revision = LabourLaw::Revision.find_by(revision_code: params[:id])
    if @revision.update(
         params[:revision].permit(:revision_name, :revision_code, :revision_status)
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

  def copy
    @revision = LabourLaw::Revision.find_by(revision_code: params[:revision_code])

    copy = @revision.dup
    copy.revision_code += "-copy"
    copy.save

    @revision.elements.each do |element|
      element_copy = copy.elements.create(
        element_code: element.element_code,
        element_index: element.element_index,
        element_text: element.element_text,
        element_type: element.element_type,
      )
      element.translations.each do |translation|
        element_copy.translations.create(
          translation_locale: translation.translation_locale,
          translation_text: translation.translation_text,
        )
      end
    end

    redirect_to "/admin/labour_law/revisions/#{copy.revision_code}"
  end
end
