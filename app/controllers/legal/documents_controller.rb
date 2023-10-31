class Legal::DocumentsController < ApplicationController
  layout "internal"

  def show
    @document = Legal::Document.find_by(document_code: params[:document_code])
    if @document.nil? then
      raise ActionController::RoutingError.new('Not Found')
    end
    redirect_to "/⛧/#{@document.document_code}/#{@document.revisions.first.revision_code}", :allow_other_host => true
  end
end