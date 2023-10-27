class Admin::LegalDocumentsController < ApplicationController
  layout "internal"

  def index
    @documents = Legal::Document.all
  end

  def edit
    @document = Legal::Document.find_by(document_code: params[:slug])
    if request.patch? then
      if @document.update(params[:document].permit(:document_name, :document_code)) then
        flash[:notice] = "document updated"
      end
    end
  end

  def new
    @document = Legal::Document.new
    if request.post? then
      @document = Legal::Document.create(params[:document].permit(:document_name, :document_code))
      if @document.valid? then
        redirect_to "/admin/legal-documents"
        flash[:notice] = "document created"
      end
    end
  end
end