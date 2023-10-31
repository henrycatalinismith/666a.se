class Admin::LegalElementsController < ApplicationController
  layout "internal"

  def edit
    @document = Legal::Document.find_by(document_code: params[:document_code])
    @revision = @document.revisions.find_by(revision_code: params[:revision_code])
    @element = @revision.elements.find_by(element_code: params[:element_code])
    if request.patch? then
      if @element.update(params[:element].permit(:element_type, :element_index, :element_locale, :element_code, :element_text))
        flash[:notice] = "element updated"
      end
    end
  end

  def new
    @document = Legal::Document.find_by(document_code: params[:document_code])
    @revision = @document.revisions.find_by(revision_code: params[:revision_code])
    @element = @revision.elements.new
    if request.post? then
      @element = @revision.elements.create(params[:element].permit(:element_type, :element_index, :element_locale, :element_code, :element_text))
      if @element.valid? then
        redirect_to "/admin/legal-documents/#{@document.document_code}"
        flash[:notice] = "element created"
      end
    end
  end
end