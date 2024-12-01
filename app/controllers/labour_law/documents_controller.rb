class LabourLaw::DocumentsController < ApplicationController
  layout "internal"

  def index
    @page_title = "English Translations of Swedish Labour Law"
    @documents = LabourLaw::Document.published
  end
end
