class LabourLaw::DocumentsController < ApplicationController
  layout "internal"

  def index
    @page_title = "English Translations of Swedish Labour Law"
    @documents = LabourLaw::Document.published
  end

  def show
    @document = LabourLaw::Document.find_by(document_code: params[:document_code])
    raise ActionController::RoutingError.new("Not Found") if @document.nil?
    redirect_to "/⛧/#{@document.document_code}/#{@document.revisions.first.revision_code}",
                allow_other_host: true
  end
end
