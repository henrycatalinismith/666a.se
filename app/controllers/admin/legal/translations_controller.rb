class Admin::Legal::TranslationsController < AdminController
  layout "internal"

  def update
    @translation = Legal::Translation.find(params[:id])
    if @translation.update(params[:translation].permit(:translation_text))
      flash[:notice] = "translation updated"
      redirect_to "/admin/legal/elements/#{@translation.element.id}"
    end
  end
end
