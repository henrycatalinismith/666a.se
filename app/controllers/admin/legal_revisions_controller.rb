class Admin::LegalRevisionsController < ApplicationController
  layout "internal"

  def edit
    @revision = Legal::Revision.find_by(revision_code: params[:revision_code])
    @document = @revision.document
  #   if request.patch? then
  #     if @document.update(params[:document].permit(:document_name, :document_code)) then
  #       flash[:notice] = "document updated"
  #     end
  #   end
  end

  def new
    @document = Legal::Document.find_by(document_code: params[:slug])
    @revision = Legal::Revision.new
    if request.post? then
      @revision = @document.revisions.create(params[:revision].permit(:revision_name, :revision_code))
      if @revision.valid? then
        redirect_to "/admin/legal-documents/#{@document.document_code}"
        flash[:notice] = "revision created"
      end
    end
  end
end