class Admin::LabourLaw::TranslationsController < AdminController
  layout "internal"

  def index
    @element = LabourLaw::Element.find(params[:element_id])
    @revision = @element.revision
    @document = @revision.document
    @translations = @element.translations
  end

  def show
    @translation = LabourLaw::Translation.find(params[:id])
    @element = @translation.element
    @revision = @element.revision
    @document = @revision.document
  end

  def update
    @translation = LabourLaw::Translation.find(params[:id])
    if @translation.update(params[:translation].permit(:translation_text))
      flash[:notice] = "translation updated"
      redirect_to "/admin/labour_law/elements/#{@translation.element.id}"
    end
  end
end
