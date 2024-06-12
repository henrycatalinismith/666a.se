class Admin::LabourLaw::RevisionsController < AdminController
  layout "internal"

  def index
    @document = LabourLaw::Document.find(params[:document_id])
    @revisions = @document.revisions
  end

  def show
    @revision = LabourLaw::Revision.find(params[:id])
    @document = @revision.document
  end

  def edit
    @revision = LabourLaw::Revision.find(params[:id])
    @document = @revision.document
  end

  def update
    @revision = LabourLaw::Revision.find(params[:id])
    if @revision.update(
         params[:revision].permit(:revision_name, :revision_code, :revision_status, :revision_notice)
       )
      redirect_to admin_labour_law_revision_path(@revision)
      flash[:notice] = "revision updated"
    end
  end

  def new
    @document = LabourLaw::Document.find(params[:document_id])
    raise ActionController::RoutingError.new("Not Found") if @document.nil?
    @revision = LabourLaw::Revision.new
  end

  def create
    @document =
      LabourLaw::Document.find(params[:revision][:document_id])
    raise ActionController::RoutingError.new("Not Found") if @document.nil?
    @revision =
      @document.revisions.create(
        params[:revision].permit(:revision_name, :revision_code)
      )
    if @revision.valid?
      redirect_to admin_labour_law_revision_path(@revision)
      flash[:notice] = "revision created"
    end
  end

  def copy
    @revision = LabourLaw::Revision.find(params[:id])

    copy = @revision.dup
    copy.revision_code += "-copy"
    copy.save

    @revision.elements.each do |element|
      element_copy = copy.elements.create(
        element_index: element.element_index,
        element_text: element.element_text,
        element_type: element.element_type,
        element_chapter: element.element_chapter,
        element_section: element.element_section,
        element_paragraph: element.element_paragraph,
        element_slug: element.element_slug,
      )
      element.translations.each do |translation|
        element_copy.translations.create(
          translation_locale: translation.translation_locale,
          translation_text: translation.translation_text,
          translation_status: translation.translation_status,
        )
      end
    end

    redirect_to "/admin/labour_law/revisions/#{copy.id}"
  end

  def destroy
    @revision = LabourLaw::Revision.find(params[:id])
    @revision.destroy
    redirect_to admin_labour_law_revisions_path(document_id: @revision.document.id)
    flash[:notice] = "revision deleted"
  end
end
