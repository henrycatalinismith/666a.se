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

  def edit
    @translation = LabourLaw::Translation.find(params[:id])
    @element = @translation.element
    @revision = @element.revision
    @document = @revision.document
  end

  def update
    @translation = LabourLaw::Translation.find(params[:id])
    if @translation.update(params[:translation].permit(:translation_text))
      flash[:notice] = "translation updated"
      redirect_to admin_labour_law_translation_path(@translation)
    end
  end

  def destroy
    @translation = LabourLaw::Translation.find(params[:id])
    @element = @translation.element
    @translation.destroy
    flash[:notice] = "translation deleted"
    redirect_to admin_labour_law_translations_path(element_id: @element.id)
  end

  def new
    @element = LabourLaw::Element.find(params[:element_id])
    @revision = @element.revision
    @document = @revision.document
    @translation = LabourLaw::Translation.new
  end

  def create
    puts params.inspect
    @element = LabourLaw::Element.find(params[:translation][:element_id])
    @revision = @element.revision
    @document = @revision.document
    @translation = LabourLaw::Translation.new(params[:translation].permit(
      :translation_locale,
      :translation_text,
    ).merge(element: @element))
    if @translation.save
      flash[:notice] = "translation created"
      redirect_to admin_labour_law_translation_path(@translation)
    end
  end
end
