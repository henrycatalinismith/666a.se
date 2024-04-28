class Admin::LabourLaw::TranslationsController < AdminController
  layout "internal"

  def update
    @translation = LabourLaw::Translation.find(params[:id])
    if @translation.update(params[:translation].permit(:translation_text))
      flash[:notice] = "translation updated"
      redirect_to "/admin/labour_law/elements/#{@translation.element.id}"
    end
  end
end
