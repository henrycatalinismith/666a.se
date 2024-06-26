class SitemapsController < ApplicationController
  def show
    @legal_documents = LabourLaw::Document.published

    respond_to do |format|
      format.xml
    end
  end
end
